class ApplicationController < ActionController::API
  def verify_clerk_token
    token = request.headers["Authorization"]&.split(" ")&.last
    if token
      begin
        # Load the public key from the file
        public_key_path = "#{Rails.root}/config/initializers/clerk_public_key.pem"
        public_key = OpenSSL::PKey::RSA.new(File.read(public_key_path))

        # Decode and verify the token
        decoded_token = JWT.decode(token, public_key, true, { algorithm: "RS256" })

        # Extract user data from the token payload
        payload = decoded_token[0]
        clerk_id = payload["sub"] # Extract 'sub' (Clerk ID) from the payload

        # Check if a user exists with the given Clerk ID
        user = User.find_by(clerk_id: clerk_id)
        if user
          # Set the current user
          @current_user = { id: user.id }
        else
          render json: { error: "Unauthorized", message: "User not found" }, status: :unauthorized
        end
      rescue JWT::DecodeError
        render json: { error: "Unauthorized", message: "Invalid token" }, status: :unauthorized
      rescue JWT::VerificationError
        render json: { error: "Unauthorized", message: "Verification failed" }, status: :unauthorized
      end
    else
      render json: { error: "Unauthorized", message: "Token not provided" }, status: :unauthorized
    end
  end
end
