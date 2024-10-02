import SwiftUI

struct LoginPageView: View {
    @State private var email: String = ""        // For email input
    @State private var password: String = ""     // For password input
    @State private var showAlert: Bool = false   // To show alerts
    @State private var errorMessage: String = "" // Error message to display in alert
    @State private var isLoggedIn: Bool = false  // Track login status
    @State private var showSignUp: Bool = false  // Track whether to show the SignUpView

    var body: some View {
        if isLoggedIn {
            DashboardView()  // Show dashboard after successful login
        } else if showSignUp {
            SignUpView(showSignUp: $showSignUp)  // Navigate to sign-up screen
        } else {
            // Login UI
            VStack {
                Spacer()

                // App Name and Icon
                VStack {
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.green)
                    Text("Alfalfa Yield Predictor")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .padding(.top, 10)
                }

                Spacer()

                // Email and Password Input
                VStack(spacing: 20) {
                    TextField("Enter your email", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)

                    SecureField("Enter your password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)

                // Login Button
                Button(action: {
                    authenticateUser()  // Validate user credentials
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                }
                .padding(.top, 20)

                // Sign-Up Button
                Button(action: {
                    showSignUp = true  // Navigate to sign-up screen
                }) {
                    Text("Sign Up")
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                }

                Spacer()

                // Footer
                Text("© 2024 Alfalfa Analytics, Inc.")
                    .font(.footnote)
                    .foregroundColor(.gray)

                Spacer()
            }
            .background(Color(.white))
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Login Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    // Authentication function
    func authenticateUser() {
        // Retrieve saved user data from UserDefaults
        let savedEmail = UserDefaults.standard.string(forKey: "email")
        let savedPassword = UserDefaults.standard.string(forKey: "password")

        // Validate email and password
        if email.isEmpty || password.isEmpty {
            errorMessage = "Please enter both email and password."
            showAlert = true
        } else if email == savedEmail && password == savedPassword {
            // Successful login
            isLoggedIn = true
        } else {
            errorMessage = "Invalid email or password. Please try again."
            showAlert = true
        }
    }
}
