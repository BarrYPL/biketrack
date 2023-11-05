![image](https://github.com/BarrYPL/biketrack/assets/33989477/ef0af9fe-11b3-4052-8060-7df8e8e2f393)# Biketrack.pro

<!-- Table of Contents -->
# :notebook_with_decorative_cover: Table of Contents

- [About the Project](#star2-about-the-project)
  * [Key Features](#star-key-features)
  * [Inspiration](#tada-inspiration)
  * [Screenshots](#camera-screenshots)
  * [Tech Stack](#space_invader-tech-stack)
- [Roadmap](#compass-roadmap)

<!-- About the Project -->
## :star2: About the Project

The presented application is designed for tracking data related to the condition of owned bicycles, as well as the dates and details of their maintenance. It operates based on data retrieved from the Strava API. The idea for this application was born out of a simple request from a friend who said, "Write something that keeps track of the kilometers since the last marked date." Since then, it has become clear that he owns more than one bicycle, and each bicycle has more than one chain. It is necessary to associate each "ride" from Strava with a specific chain and bicycle based on the last change date of the chain. Additionally, the application allows users to add notes about other maintenance work along with relevant dates.

<!-- Key Features -->
### :star: Key Features
- Bicycle Data Tracking: Easily track the condition of multiple bicycles, including details about each bike's specifications.

- Chain Management: Associate each ride recorded on Strava with a specific chain and bicycle, all based on the last change date of the chain.

- Maintenance Notes: Keep a record of maintenance activities with accompanying dates, ensuring a comprehensive maintenance history.

- Strava Integration: Seamlessly integrate with the Strava API to retrieve and link ride data.

- User-Friendly Interface: The application provides an intuitive user interface for easy navigation and data entry.

<!-- Inspiration -->
### :tada: Inspiration
The inspiration for this application came from a friend's need to keep track of the kilometers ridden since the last mainstence. What initially seemed like a straightforward request quickly evolved as it became evident that he has much more ideas. This complexity led to the development of a comprehensive solution for tracking and managing bicycle data effectively.

<!-- Screenshots -->
### :camera: Screenshots
<div align="center"> 
  <img src="https://github.com/BarrYPL/biketrack/blob/main/app/assets/images/main.png?raw=true" alt="screenshot" />
  App Main View
</div>

<div align="center"> 
  <img src="https://github.com/BarrYPL/biketrack/blob/main/app/assets/images/stats.png?raw=true" alt="screenshot" />
  App Services View
</div>

<div align="center"> 
  <img src="https://github.com/BarrYPL/biketrack/blob/main/app/assets/images/views.png?raw=true" alt="screenshot" />
  App Stats View
</div>

<!-- TechStack -->
### :space_invader: Tech Stack

<details>
  <summary>Server</summary>
  <ul>
    <li><a href="https://www.ruby-lang.org/">Ruby</a></li>
    <li><a href="https://rubyonrails.org">Rails Framework</a></li>
    <li><a href="https://oauth.net/2/">Rails Framework</a></li>
  </ul>
</details>

## :compass: Roadmap

* [ ] Add counting each chain total distance
* [ ] Add customized bikes images
* [ ] Add loading rides in background
