# NetCore

[![Version](https://img.shields.io/cocoapods/v/CarotaService.svg?style=flat)](https://cocoapods.org/pods/MPService)
[![License](https://img.shields.io/cocoapods/l/CarotaService.svg?style=flat)](https://cocoapods.org/pods/MPService)
[![Platform](https://img.shields.io/cocoapods/p/CarotaService.svg?style=flat)](https://cocoapods.org/pods/MPService)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

NetCore is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'NetCore'
```

## NetCore Reference

### HTTP Enums

- `HTTPMethod`
  - `.get`
  - `.post`
  - `.put`
  - `.patch`
  - `.delete`

- `HTTPAuthentication`
  - `.basic(username: String, password: String)` — encodes credentials as an HTTP Basic Authorization header.
  - `.bearer(token: String)` — encodes a bearer token as an HTTP Authorization header.
  - `value` — computed property returning the header value string.

- `HTTPHeaderField`
  - `.contentType`
  - `.authorization`

- `HTTPBody`
  - `.json(object: Encodable)` — encodes an `Encodable` object as JSON and sets content type to `application/json`.
  - `.formData` — placeholder for multipart/form-data bodies, currently returns empty `Data`.

### NCError

`NCError` is the error enum used by NetCore and contains:

- `.invalidURL`
- `.invalidResponseStatus`
- `.dataTaskError(String?)`
- `.corruptData`
- `.decodingError(String)`
- `.encodingError`
- `.unauthorized`
- `.notFound`
- `.serverError`
- `.requestError`
- `.unknown`

### URLConvertible

`URLConvertible` is a protocol that exposes a single method:

- `asURL() -> URL?`

Types conforming to `URLConvertible` in this library are:

- `String`
- `URL`

This allows `NCClient` request methods to accept either a URL string or a `URL` instance.

### NCClient

Use `NCClient.shared` to make requests and manage optional authorization.

Public methods:

- `setAuthorization(_ auth: HTTPAuthentication)`
- `clearAuthorization()`
- `request(url: URLConvertible, method: HTTPMethod, body: HTTPBody?, completion: @escaping NCCompletion)` — request returning raw `Data` with completion.
- `request<T: Decodable>(url: URLConvertible, method: HTTPMethod, body: HTTPBody?, completion: @escaping NCDecodedCompletion<T>)` — request returning decoded `T` with completion.
- `request(url: URLConvertible, method: HTTPMethod, body: HTTPBody?) async throws -> Data` — async request returning raw `Data`.
- `request<T: Decodable>(url: URLConvertible, method: HTTPMethod, body: HTTPBody?) async throws -> T` — async request returning decoded `T`.

### Example Usage

```swift
import NetCore

// Network Client
let client = NCClient.shared

// Set authorization if your API requires it
client.setAuthorization(.bearer(token: "YOUR_TOKEN"))

// URL String
let urlString = "https://jsonplaceholder.typicode.com/posts/1"

// 1) Completion-based raw data request
client.request(url: urlString) { result in
    switch result {
    case .success(let data):
        print("Received data with size: \(data.count)")
    case .failure(let error):
        print("Request failed: \(error.localizedDescription)")
    }
}

// 2) Completion-based decoded request
struct Post: Decodable {
    let id: Int
    let title: String
    let body: String
}

client.request(url: urlString) { (result: Result<Post, NCError>) in
    switch result {
    case .success(let post):
        print("Post title: \(post.title)")
    case .failure(let error):
        print("Failed to decode post: \(error.localizedDescription)")
    }
}

// 3) Async/await raw data request
Task {
    do {
        let data = try await client.request(url: urlString)
        print("Async received data of length: \(data.count)")
    } catch {
        print("Async request error: \(error)")
    }
}

// 4) Async/await decoded request
Task {
    do {
        let post: Post = try await client.request(url: urlString)
        print("Async decoded post title: \(post.title)")
    } catch {
        print("Async decode error: \(error)")
    }
}

// 5) Completion-based POST with JSON body
struct NewPost: Encodable {
    let title: String
    let body: String
    let userId: Int
}

let newPost = NewPost(title: "Hello", body: "World", userId: 1)

client.request(
    url: urlString,
    method: .post,
    body: .json(object: newPost)
) { (result: Result<Post, NCError>) in
    switch result {
    case .success(let post):
        print("Created post id: \(post.id)")
    case .failure(let error):
        print("Failed to create post: \(error.localizedDescription)")
    }
}
```

## Author

Elias Ferreira, eliasferreira.pro@gmail.com

## License

NetCore is available under the MIT license. See the LICENSE file for more info.
