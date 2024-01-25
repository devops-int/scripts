import requests
import mysql.connector

def get_random_activity():
    api_url = "https://www.boredapi.com/api/activity"

    try:
        response = requests.get(api_url)

        if response.status_code == 200:
            activity_data = response.json()
            random_activity = activity_data.get("activity")
            
            db_connection = mysql.connector.connect(
                host="*********",
                user="admin",
                password="*********",
                database="INFO"
            )

            cursor = db_connection.cursor()

            insert_query = "INSERT INTO Activity (Description) VALUES (%s)"
            activity_values = (random_activity,) #The coma is to create a tuple so that it matches the expected format for the parameter in the execute method
            cursor.execute(insert_query, activity_values)

            db_connection.commit()
            print("The response code is: {}".format(response.status_code))
            print("Random Activity '{}' inserted into the 'Activity' table.".format(random_activity))

            cursor.close()
            db_connection.close()

        else:
            print("Error. Status code: {}".format(response.status_code))

    except Exception as e:
        print("Catched an arror: {}".format(e))

if __name__ == "__main__":
    get_random_activity()

