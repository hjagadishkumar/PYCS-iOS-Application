import SwiftUI

struct SignUpView: View {
    @Binding var showSignUp: Bool
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        VStack {
            Spacer()

            // Title
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 30)

            // Input Fields
            VStack(spacing: 20) {
                TextField("First Name", text: $firstName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                TextField("Last Name", text: $lastName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 30)

            // Sign Up Button
            Button(action: {
                signUpUser()
            }) {
                Text("Create Account")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
            }
            .padding(.top, 20)

            // Back to Login
            Button(action: {
                showSignUp = false  // Navigate back to login
            }) {
                Text("Back to Login")
                    .foregroundColor(.blue)
                    .padding(.top, 10)
            }

            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Sign Up"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    // Function to save user data during sign-up
    func signUpUser() {
        if firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty {
            alertMessage = "Please fill out all fields."
            showAlert = true
        } else {
            // Store user data in UserDefaults
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set(password, forKey: "password")

            alertMessage = "Account created successfully for \(firstName) \(lastName)!"
            showAlert = true
            showSignUp = false  // Navigate back to login after sign-up
        }
    }
}
