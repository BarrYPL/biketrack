class CreateUserInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :user_infos do |t|
      t.string :token_type
      t.integer :expires_at
      t.integer :expires_in
      t.string :refresh_token
      t.string :access_token
      t.integer :athlete_id
      t.string :athlete_username
      t.integer :athlete_resource_state
      t.string :athlete_firstname
      t.string :athlete_lastname
      t.string :athlete_bio
      t.string :athlete_city
      t.string :athlete_state
      t.string :athlete_country
      t.string :athlete_sex
      t.boolean :athlete_premium
      t.boolean :athlete_summit
      t.datetime :athlete_created_at
      t.datetime :athlete_updated_at
      t.integer :athlete_badge_type_id
      t.float :athlete_weight
      t.string :athlete_profile_medium
      t.string :athlete_profile
      t.integer :athlete_friend_id
      t.integer :athlete_follower_id
      t.timestamps
    end
  end
end
