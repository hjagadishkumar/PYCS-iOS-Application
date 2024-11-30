import SwiftUI

struct LoginPageView: View {
    @State private var email: String = ""        // For email input
    @State private var password: String = ""     // For password input
    @State private var showAlert: Bool = false   // To show alerts
    @State private var errorMessage: String = "" // Error message to display in alert
    @State private var isLoggedIn: Bool = false  // Track login status
    @State private var showSignUp: Bool = false  // Track whether to show the SignUpView
    @State private var logoAnimation = false     // Animation state for logo

    var body: some View {
        if isLoggedIn {
            DashboardView()  // Show dashboard after successful login
        } else if showSignUp {
            SignUpView(showSignUp: $showSignUp)  // Navigate to sign-up screen
        } else {
            // Login UI
            VStack {
                Spacer()

                // App Name and Icon with Animation
                VStack {
                    Image("pycs_logo")  // Ensure this matches the name of the image set in Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .padding(.bottom, 10)
                        .scaleEffect(logoAnimation ? 1.2 : 1.0)  // Animation effect
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                logoAnimation = true
                            }
                        }

                    Text("PYCS")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .padding(.top, 10)
                    
                    Text("(Predict Your CropS) ")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .padding(.top, 10)

                }

                Spacer()

                // Email and Password Input with improved style
                VStack(spacing: 20) {
                    TextField("Enter your email", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.green, lineWidth: 1)
                        )
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.emailAddress)

                    SecureField("Enter your password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.green, lineWidth: 1)
                        )
                }
                .padding(.horizontal, 30)

                // Login Button with animation
                Button(action: {
                    authenticateUser()  // Validate user credentials
                }) {
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.white)
                        Text("Login")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                    .shadow(color: .green.opacity(0.5), radius: 5, x: 0, y: 5)
                    .padding(.horizontal, 30)
                    .scaleEffect(1.05)
                }
                .padding(.top, 20)
                .animation(.easeIn(duration: 0.6), value: isLoggedIn)

                // Sign-Up Button with animation
                Button(action: {
                    showSignUp = true  // Navigate to sign-up screen
                }) {
                    Text("Don’t have an account? Sign Up")
                        .foregroundColor(.blue)
                        .font(.headline)
                        .underline()
                        .padding(.top, 10)
                }
                .padding(.top, 10)
                .animation(.easeIn(duration: 0.6), value: showSignUp)

                Spacer()

                // Footer with custom style
                Text("© 2024 PYCS Analytics, Inc. All rights reserved.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)

                Spacer()
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [.white, .green.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
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

struct LoginPageView_Previews: PreviewProvider {
    static var previews: some View {
        LoginPageView()
    }
}
