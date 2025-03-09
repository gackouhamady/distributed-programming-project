# WebProgrammingProject


## Overview
This project is a simple RESTful web service designed to manage a car rental system. The application provides endpoints to:

1. Retrieve a list of unrented cars.
2. Rent a car.
3. Return a rented car.

Built using **Spring Boot**, this project demonstrates fundamental REST API principles and microservice architecture in a lightweight implementation.

---

## Features

- **Unrented Cars Listing:** Get a list of all cars available for rental.
- **Car Details:** Retrieve detailed information about a specific car, including its plate number, brand, price, and rental status.
- **Rent or Return a Car:** Update the rental status of a car with a simple HTTP request.

---

## Project Architecture

- **Model Layer:** Defines the `Car` class, which includes attributes like `plateNumber`, `brand`, `price`, and `rented`.
- **Repository Layer:** Manages an in-memory list of cars and provides methods to retrieve or update car data.
- **Controller Layer:** Exposes RESTful endpoints to interact with the application.

---

## API Endpoints

### Base URL
`http://localhost:8080`

### Endpoints

1. **Get Unrented Cars**
    - **Method:** `GET`
    - **Endpoint:** `/cars`
    - **Description:** Retrieves a list of all unrented cars.

2. **Get Car Details**
    - **Method:** `GET`
    - **Endpoint:** `/cars/{plateNumber}`
    - **Description:** Retrieves details of a specific car by its plate number.

3. **Rent a Car**
    - **Method:** `PUT`
    - **Endpoint:** `/cars/{plateNumber}?rent=true`
    - **Description:** Updates the car status to rented.

4. **Return a Car**
    - **Method:** `PUT`
    - **Endpoint:** `/cars/{plateNumber}?rent=false`
    - **Description:** Updates the car status to available.

---

5. **To  restitue with  poweshell a car on  my Windows** :
```PowerShell
 Invoke-RestMethod -Uri "http://localhost:8080/cars/11AA22?rent=true" -Method Put -Headers @{"Content-Type"="application/json"} -Body '{"begin":"4/11/2024","end":"20/11/2024"}'

PS C:\Users\MLSD> if ($?) {
>>     "The command succeeded."
>> } else {
>>     "The command failed."
>> }
```
6. **To restitue a car on Postman**:
```
Méthode HTTP : PUT
URL : http://localhost:8080/cars/11AA22?rent=true
Headers :
Content-Type: application/json
Body :
Sélectionnez l'option raw : Entrez le contenu suivant :
 {
  "begin": "4/11/2024",
  "end": "20/11/2024"
}

```


## How to Run

1. Clone the repository.
2. Open the project in your preferred IDE (Eclipse or IntelliJ IDEA).
3. Run the `main` method in the `Application.java` file.
4. Access the API via `http://localhost:8080` using tools like Postman or a web browser.

---

## Future Improvements

- Add authentication and authorization for API endpoints.
- Implement input validation for car data.
- Enhance error handling to return more user-friendly messages.

---

## Contributing

Feel free to fork this repository and contribute by submitting pull requests. Suggestions and improvements are always welcome!

---

## Copy Rights :

All Rights Reserved
.
