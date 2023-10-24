class GetUserData
    include Sidekiq::Job

    def perform(book_loan_id)
        UserProfileController.getUserData
    end
end