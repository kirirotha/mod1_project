# mod1_project# 
The Time Now - A Tracking CLI App
​
## Models & Relationships
### Route -< Workout >- User


User has many Workouts 
User has many Routes through Workouts


Route has many Workouts
Route has many Users through Workouts


A Workout belongs to a Route
A Workout belongs to an User

---------------------------------------------------


-A user can log in view all of thier workout history and stats
-A user can browse route for workout
-User can record a workout route
-User can view total stats of a workout(average speed, caloires burnt, distance, elevevation gain/lost)
-The app shoud update routes based on user feedback


-Different routes have multiple distances, terrain and elevation change
-Users can have different weights, gender
-App can output top 5 times for a route
-App an output most active User
-App can calculate calories burned
-Routes have ratings
-Users can add new routes
-Puts exit message

----------------------------------------------------

## Models & Relationships
### Item -< Purchase >- User

User has many Workouts
User has many Routes through Workouts

Route has many Workouts
Route has many Users through Workouts

A Workout belongs to a Route
A Workout belongs to an User

#Class Instance Variables

###User has many Workouts 
-Name
-Weight
-Height
-Gender

##Workout
-User_id
-Route_id
-Type(Walk, Run, Bike)
-Completed/Number of Laps
-Rating
-Comments

##Route
-Name
-Distance(km/miles)
-Elevation
-Terrain(Road,Gravel,etc)





