import SwiftUI

struct SignUpView: View {
    @Binding var showSignUp: Bool
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var animateButton = false // For button animation

    var body: some View {
        VStack {
            Spacer()

            // App Name and Icon with Animation
            VStack {
                Image("pycs_logo") // Reference the image from the Assets catalog
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.bottom, 10)
                    .scaleEffect(animateButton ? 1.2 : 1.0)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                            animateButton = true
                        }
                    }

                Text("PYCS")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(.top, 10)
                Text("(Predict Your CropS)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(.top, 10)
            }

            Spacer()

            // Input Fields with improved styling
            VStack(spacing: 20) {
                TextField("First Name", text: $firstName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.green, lineWidth: 1)
                    )

                TextField("Last Name", text: $lastName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.green, lineWidth: 1)
                    )

                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.green, lineWidth: 1)
                    )
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.green, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 30)

            // Sign Up Button with animation and style
            Button(action: {
                signUpUser()
            }) {
                HStack {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .foregroundColor(.white)
                    Text("Create Account")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(10)
                .shadow(color: .green.opacity(0.5), radius: 5, x: 0, y: 5)
                .padding(.horizontal, 30)
            }
            .padding(.top, 20)

            // Back to Login Button with subtle animation
            Button(action: {
                withAnimation {
                    showSignUp = false  // Navigate back to login
                }
            }) {
                Text("Back to Login")
                    .foregroundColor(.blue)
                    .font(.headline)
                    .underline()
                    .padding(.top, 10)
            }

            Spacer()
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [.white, .green.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
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

struct SignUpView_Previews: PreviewProvider {
    @State static var showSignUp = true
    static var previews: some View {
        SignUpView(showSignUp: $showSignUp)
    }
}
