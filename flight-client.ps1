
$baseUrl = "http://localhost:8081"

Write-Host "Welcome to the Flight Booking System!" -ForegroundColor Cyan

while ($true) {
    $resource = Read-Host "Choose what you want to manage: FLIGHT, BOOKING, USER (or type 'exit' to quit)"
    if ($resource -eq "exit") { break }

    # Show friendly options based on resource
    $actionPrompt = switch ($resource.ToUpper()) {
        "FLIGHT"  { "Choose operation: 1-View flights, 2-Add flight, 3-Update flight, 4-Delete flight" }
        "BOOKING" { "Choose operation: 1-View bookings, 2-Book a flight, 3-Cancel a booking" }
        "USER"    { "Choose operation: 1-View users, 2-Register new user, 3-Delete user" }
        Default   { Write-Host "Invalid choice! Enter FLIGHT, BOOKING, USER or exit." -ForegroundColor Red; continue }
    }
    $actionChoice = Read-Host $actionPrompt

    # Map friendly numbers to operations
    $operation = switch ($actionChoice) {
        "1" { "GET" }
        "2" { "POST" }
        "3" { if ($resource -eq "FLIGHT") { "PUT" } else { "DELETE" } }
        "4" { "DELETE" }
        Default { Write-Host "Invalid operation choice!" -ForegroundColor Red; continue }
    }

    try {
        switch ($resource.ToUpper()) {
            "FLIGHT" {
                switch ($operation) {
                    "GET" {
                        $id = Read-Host "Enter flight ID (leave blank for all)"
                        if ([string]::IsNullOrWhiteSpace($id)) {
                            $response = Invoke-RestMethod -Uri "$baseUrl/api/flights" -Method GET
                        } else {
                            $response = Invoke-RestMethod -Uri "$baseUrl/api/flights/$id" -Method GET
                        }

                        # Display in table
                        if ($response -is [System.Array]) {
                            $response | Format-Table flightNumber, airline, source, destination, departureTime, arrivalTime, availableSeats, price -AutoSize
                        } else {
                            $response | Format-Table flightNumber, airline, source, destination, departureTime, arrivalTime, availableSeats, price -AutoSize
                        }
                    }
# ----------------- ADD FLIGHT -----------------
"POST" {
    $flightNumber = Read-Host "Enter flight number"
    $airline = Read-Host "Enter airline"
    $source = Read-Host "Enter source"
    $destination = Read-Host "Enter destination"
    $departureTime = Read-Host "Enter departure time (yyyy-MM-dd HH:mm:ss)"
    $arrivalTime = Read-Host "Enter arrival time (yyyy-MM-dd HH:mm:ss)"
    $availableSeats = Read-Host "Enter available seats"
    $price = Read-Host "Enter price"

    $body = @{
        flightNumber   = $flightNumber
        airline        = $airline
        source         = $source
        destination    = $destination
        departureTime  = $departureTime
        arrivalTime    = $arrivalTime
        availableSeats = [int]$availableSeats
        price          = [double]$price
    } | ConvertTo-Json

    # Invoke POST
    $response = Invoke-RestMethod -Uri "$baseUrl/api/flights" -Method POST -ContentType "application/json" -Body $body

    # Show flight ID and message
    Write-Host "✈️ $($response.message) Flight ID: $($response.id)" -ForegroundColor Green
}


# ----------------- UPDATE FLIGHT -----------------
"PUT" {
    $id = Read-Host "Enter flight ID to update"
    $flightNumber = Read-Host "Enter flight number"
    $airline = Read-Host "Enter airline"
    $source = Read-Host "Enter source"
    $destination = Read-Host "Enter destination"
    $departureTime = Read-Host "Enter departure time (yyyy-MM-dd HH:mm:ss)"
    $arrivalTime = Read-Host "Enter arrival time (yyyy-MM-dd HH:mm:ss)"
    $availableSeats = Read-Host "Enter available seats"
    $price = Read-Host "Enter price"

    $body = @{
        flightNumber   = $flightNumber
        airline        = $airline
        source         = $source
        destination    = $destination
        departureTime  = $departureTime
        arrivalTime    = $arrivalTime
        availableSeats = [int]$availableSeats
        price          = [double]$price
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri "$baseUrl/api/flights/$id" -Method PUT -ContentType "application/json" -Body $body
    Write-Host "✈️ Flight updated successfully! Flight ID: $($response.id)" -ForegroundColor Green
}

                    "DELETE" {
                        $id = Read-Host "Enter flight ID to delete"
                        Invoke-RestMethod -Uri "$baseUrl/api/flights/$id" -Method DELETE
                        Write-Host "✅ Flight deleted successfully." -ForegroundColor Green
                    }
                }
            }

            "BOOKING" {
                switch ($operation) {
                  "GET" {
                      $id = Read-Host "Enter booking ID (leave blank for all)"
                      try {
                          if ([string]::IsNullOrWhiteSpace($id)) {
                              $response = Invoke-RestMethod -Uri "$baseUrl/api/bookings" -Method GET
                          }
                          else {
                              $response = Invoke-RestMethod -Uri "$baseUrl/api/bookings/$id" -Method GET
                          }

                          # Display in table
                          if ($response -is [System.Array]) {
                              $response | Format-Table id, @{Name="user";Expression={$_.user.name}}, @{Name="flight";Expression={$_.flight.flightNumber}}, seatsBooked, bookingDate, status -AutoSize
                          } else {
                              $response | Format-Table id, @{Name="user";Expression={$_.user.name}}, @{Name="flight";Expression={$_.flight.flightNumber}}, seatsBooked, bookingDate, status -AutoSize
                          }
                      }
                      catch {
                          if ($_.Exception.Response.StatusCode.value__ -eq 404) {
                              Write-Host "❌ Booking not found." -ForegroundColor Yellow
                          } else {
                              Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
                          }
                      }
                  }

                    "POST" {
                        $userId = Read-Host "Enter user ID"
                        $flightId = Read-Host "Enter flight ID"
                        $seatsBooked = Read-Host "Enter number of seats to book"

                        Invoke-RestMethod -Uri "$baseUrl/api/bookings/book?userId=$userId&flightId=$flightId&seatsBooked=$seatsBooked" -Method POST
                        Write-Host "✅ Booking created successfully." -ForegroundColor Green
                    }
                    "DELETE" {
                        $id = Read-Host "Enter booking ID to cancel"
                        Invoke-RestMethod -Uri "$baseUrl/api/bookings/cancel/$id" -Method DELETE
                        Write-Host "✅ Booking cancelled successfully." -ForegroundColor Green
                    }
                }
            }

            "USER" {
                switch ($operation) {
                    "GET" {
                        $idOrEmail = Read-Host "Enter user ID or email (leave blank for all)"
                        if ([string]::IsNullOrWhiteSpace($idOrEmail)) {
                            $response = Invoke-RestMethod -Uri "$baseUrl/api/users" -Method GET
                        }
                        elseif ($idOrEmail -match "^[0-9]+$") {
                            $response = Invoke-RestMethod -Uri "$baseUrl/api/users/$idOrEmail" -Method GET
                        } else {
                            $response = Invoke-RestMethod -Uri "$baseUrl/api/users/email/$idOrEmail" -Method GET
                        }

                        # Display in table
                        if ($response -is [System.Array]) {
                            $response | Format-Table id, name, email -AutoSize
                        } else {
                            $response | Format-Table id, name, email -AutoSize
                        }
                    }
                    "POST" {
                        $name = Read-Host "Enter name"
                        $email = Read-Host "Enter email"
                        $password = Read-Host "Enter password"

                        $body = @{
                            name = $name
                            email = $email
                            password = $password
                        } | ConvertTo-Json

                        Invoke-RestMethod -Uri "$baseUrl/api/users/register" -Method POST -ContentType "application/json" -Body $body
                        Write-Host "✅ User registered successfully." -ForegroundColor Green
                    }
                    "DELETE" {
                        $id = Read-Host "Enter user ID to delete"
                        Invoke-RestMethod -Uri "$baseUrl/api/users/$id" -Method DELETE
                        Write-Host "✅ User deleted successfully." -ForegroundColor Green
                    }
                }
            }

        }
    } catch {
        Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}