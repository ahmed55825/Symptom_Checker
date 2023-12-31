const express = require("express");
const mysql = require("mysql");
const session = require("express-session");
const ejs = require("ejs");
const path = require("path");
const { promises } = require("dns");
const { resourceLimits } = require("worker_threads");
const app = express();
const port = 3000;

app.use(
  session({
    secret: "Some-secret",
    resave: false,
    saveUninitialized: false,
  })
);

// Middleware to parse request body
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// // Create a connection to the MySQL database
// const connection = mysql.createConnection({
//   host: "localhost",
//   user: "root",
//   password: "root",
//   database: "symptom_checker",
// });

// // Connect to the database
// connection.connect((error) => {
//   if (error) {
//     console.error("Error connecting to the database: ", error);
//   } else {
//     console.log("Connected to database!");
//   }
// });

// Set up a route to handle form submissions
app.post("/sign-up", async (req, res) => {
  try {
    const { name, age, phone, cnic } = req.body;
    const role = "General User";

    const query =
      "INSERT INTO User (Name, Age, CNIC, Phone, role) VALUES (?, ?, ?, ?, ?)";

    await new Promise((resolve, reject) => {
      connection.query(
        query,
        [name, age, cnic, phone, role],
        (error, results, fields) => {
          if (error) {
            console.error("Error inserting user data: ", error);
            reject(error);
          } else {
            console.log("User data inserted successfully!");
            resolve();
          }
        }
      );
    });

    const get_user_id = `SELECT user_id FROM User WHERE Name = ? AND CNIC = ?`;

    const results2 = await new Promise((resolve, reject) => {
      connection.query(get_user_id, [name, cnic], (error, results) => {
        if (error) {
          console.error("Error getting user_id from User table: ", error);
          reject(error);
        } else {
          console.log("Successfully got the user_id from User table!");
          resolve(results);
        }
      });
    });

    req.session.name = name;
    req.session.user_id = results2[0].user_id;
    req.session.justSignedUp = true;

    res.redirect("/disease_info");
  } catch (error) {
    console.log("Some error occurred:", error);
    res.redirect("/sign-up");
  }
});

// --------------------------------------------------------------------------------------------------------------

app.post("/login/logged-in", async (req, res) => {
  const { name, user_id } = req.body;

  // Insert the form data into the database
  const check_query =
    "SELECT * FROM symptom_checker.user WHERE user_id = ? AND Name = ?;";

  try {
    const results = await new Promise((resolve, reject) => {
      connection.query(check_query, [user_id, name], (err, results) => {
        if (err) {
          console.log("Error getting user name: ", err);
          reject(err);
        } else {
          resolve(results);
        }
      });
    });

    req.session.user_id = results[0].user_id;
    console.log(req.session.user_id);

    req.session.Name = results[0].Name;
    console.log(req.session.Name);

    if (results[0].role === "General User") {
      res.redirect("/disease_info");
    } else if (results[0].role === "Doctor") {
      res.redirect("/post");
    } else {
      res.redirct("admin-view");
    }
  } catch {
    res.redirect("/log-in");
  }
});

// --------------------------------------------------------------------------------------------------------------

app.post("/disease_info/added", async (req, res) => {
  const { disease_name } = req.body;
  const Description = "test";
  const user_id = req.session.user_id;
  console.log(user_id);

  const insert_disease_name =
    "INSERT INTO user_disease(Name, Description, user_id) value (?, ?, ?);";

  try {
    const results = await new Promise((resolve, reject) => {
      connection.query(
        insert_disease_name,
        [disease_name, Description, user_id],
        (err, results) => {
          if (err) {
            console.log("Error in inserting into disease table ", err);
            reject(err);
          } else {
            resolve(results);
          }
        }
      );
    });

    const get_symptoms = `SELECT s.symptom_name, s.Description, c.name FROM symptoms s
                          JOIN symptoms_cure sc ON s.symptom_id = sc.symptom_id 
                          join cure c ON sc.cure_id=c.cure_id
                          WHERE s.symptom_name = ?;
    `;

    try {
      const results2 = await new Promise((resolve, reject) => {
        connection.query(get_symptoms, [disease_name], (err, results2) => {
          if (err) {
            console.log("Error in getting symptoms info ", err);
            reject(err);
          } else {
            resolve(results2);
          }
        });
      });

      if (results2.length === 0) {
        console.log("value entered is not present in symptoms table");
        res.redirect("/disease_info");
      } else {
        res.render("tables/diseases_name", { data: results2 });
      }
    } catch (error) {
      console.log(error);
    }
  } catch (error) {
    console.log(error);
    res.redirect("/disease_info");
  }
});

// --------------------------------------------------------------------------------------------------------------

app.post("/post/added", async (req, res) => {
  try {
    const { title, author, content } = req.body;

    const get_doctor_id = `SELECT doctor_id FROM doctor WHERE Name = ?;`;

    const results = await new Promise((resolve, reject) => {
      connection.query(get_doctor_id, [author], (err, results) => {
        if (err) {
          console.log("Error getting doctor_id from doctor table: ", err);
          reject(err);
        } else {
          if (results.length === 0) {
            reject(new Error("Doctor not found in the doctor table", err));
          } else {
            console.log("Successfully got doctor_id!");
            resolve(results);
          }
        }
      });
    });

    console.log(results);

    const query =
      "INSERT INTO post (Title, Description, Date, doctor_id) VALUES (?, ?, NOW(), ?)";

    await new Promise((resolve, reject) => {
      connection.query(
        query,
        [title, content, results[0].doctor_id],
        (error, results, fields) => {
          if (error) {
            console.error(
              "Error inserting doctor post into post table: ",
              error
            );
            reject(error);
          } else {
            console.log("Doctor post inserted successfully!");
            resolve();
          }
        }
      );
    });

    res.redirect("/post");
  } catch (error) {
    console.log("Some error occurred:", error);
    res.redirect("/log-in");
  }
});

// --------------------------------------------------------------------------------------------------------------

app.get("/view-post", async (req, res) => {
  const get_doctor_post = `
    SELECT p.Title, p.Description, p.Date, d.name 
    FROM post p
    JOIN doctor d ON d.doctor_id = p.doctor_id;
  `;

  try {
    const results = await new Promise((resolve, reject) => {
      connection.query(get_doctor_post, (err, results) => {
        if (err) {
          reject(new Error("ERROR in getting doctor post", err));
        } else {
          console.log("Got doctor post");
          resolve(results);
        }
      });
    });

    res.render("tables/doctor_post", { data: results });
  } catch (error) {
    console.log(error);
    res.redirect("/");
  }
});

// --------------------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------

app.get("/admin-view", async (req, res) => {
  res.sendFile(__dirname + "/views/Admin_view.html");
});

// --------------------------------------------------------------------------------------------------------------

app.get("/admin/view-doctors", async (req, res) => {
  const get_doctor_info = `
    SELECT  d.doctor_id, d.Name, d.Age, d.user_id, s.Name AS speciality_name
    FROM doctor d
    JOIN doctor_speciality ds ON ds.doctor_id = d.doctor_id
    JOIN speciality s ON s.speciality_id = ds.speciality_id;
  `;

  try {
    const results = await new Promise((resolve, reject) => {
      connection.query(get_doctor_info, (err, results) => {
        if (err) {
          reject(new Error("ERROR in getting doctor info", err));
        } else {
          console.log("Got doctor info");
          resolve(results);
        }
      });
    });

    res.render("tables/view_doctors_table", { doctor: results });
  } catch (err) {
    console.log(err);
    res.redirect("/log-in");
  }
});

// --------------------------------------------------------------------------------------------------------------

app.get("/admin/view-users", async (req, res) => {
  const get_user_info = `
    SELECT * FROM user;
  `;

  try {
    const results = await new Promise((resolve, reject) => {
      connection.query(get_user_info, (err, results) => {
        if (err) {
          reject(new Error("ERROR in getting user info", err));
        } else {
          console.log("Got user info");
          resolve(results);
        }
      });
    });

    res.render("tables/view_users_table", { user: results });
  } catch (err) {
    console.log(err);
    res.redirect("/log-in");
  }
});

// --------------------------------------------------------------------------------------------------------------

app.post("/admin/new_doctor", async (req, res) => {
  const {
    doctor_name,
    doctor_age,
    doctor_speciality,
    doctor_phone,
    doctor_CNIC,
  } = req.body;

  try {
    const insert_user_query = `
        INSERT INTO user (Name, Age, Phone, CNIC, role) 
        VALUES (?, ?, ?, ?, "Doctor");
        `;

    await new Promise((resolve, reject) => {
      connection.query(
        insert_user_query,
        [doctor_name, doctor_age, doctor_phone, doctor_CNIC],
        (err, results) => {
          if (err) {
            console.log("Error inserting User information", err);
            reject(err);
          } else {
            console.log("User information inserted successfully!");
            resolve(results);
          }
        }
      );
    });

    const get_user_id = `
          SELECT LAST_INSERT_ID() AS user_id;
        `;

    const result = await new Promise((resolve, reject) => {
      connection.query(get_user_id, (err, results) => {
        if (err) {
          console.log("Error getting User_id", err);
          reject(err);
        } else {
          console.log("successfully got User_id!");
          resolve(results);
        }
      });
    });

    const user_id = result[0].user_id;

    const insertQuery = `
        INSERT INTO Doctor (Name, age, user_id) 
        VALUES (?, ?, ?);
    `;
    await new Promise((resolve, reject) => {
      connection.query(
        insertQuery,
        [doctor_name, doctor_age, user_id],
        (err, results) => {
          if (err) {
            console.log("Error inserting Doctor information", err);
            reject(err);
          } else {
            console.log("Doctor information inserted successfully!");
            resolve(results);
          }
        }
      );
    });

    const getDoctorIdQuery = `
    SELECT LAST_INSERT_ID() AS doctor_id;
  `;

    const results = await new Promise((resolve, reject) => {
      connection.query(getDoctorIdQuery, (err, results) => {
        if (err) {
          console.log("Error getting Doctor_id", err);
          reject(err);
        } else {
          console.log("successfully got Doctor_id!");
          resolve(results);
        }
      });
    });

    const insert_doctor_speciality = `
    INSERT INTO doctor_speciality (doctor_id, speciality_id) VALUE
      (?,?);
  `;

    await new Promise((resolve, reject) => {
      connection.query(
        insert_doctor_speciality,
        [results[0].doctor_id, doctor_speciality],
        (err, results) => {
          if (err) {
            console.log("Error getting Doctor_id", err);
            reject(err);
          } else {
            console.log("successfully got Doctor_id!");
            resolve(results);
          }
        }
      );
    });

    callAdminView(res);
  } catch (error) {
    console.error(error);
    res.redirect("/log-in");
  }
});

// --------------------------------------------------------------------------------------------------------------

app.post("/admin/update_doctor", async (req, res) => {
  const { existing_doctor_id, new_doctor_name, doctor_age, doctor_phone } =
    req.body;

  try {
    const get_user_id = `
    SELECT user_id FROM doctor WHERE doctor_id = ?;
  `;

    const results = await new Promise((resolve, reject) => {
      connection.query(get_user_id, [existing_doctor_id], (err, results) => {
        if (err) {
          console.log("Error getting Doctor user_id", err);
          reject(err);
        } else {
          console.log("successfully got Doctor user_id!");
          resolve(results);
        }
      });
    });

    const updateQuery = `
        UPDATE doctor SET Name = ?, Age = ? 
        WHERE doctor_id = ?;
    `;

    await new Promise((resolve, reject) => {
      connection.query(
        updateQuery,
        [new_doctor_name, doctor_age, existing_doctor_id],
        (err, results) => {
          if (err) {
            console.log("Error updating doctor information", err);
            reject(err);
          } else {
            console.log("doctor information updated successfully!");
            resolve(results);
          }
        }
      );
    });

    const update_user_table = `
        UPDATE user SET Name = ?, Age = ? 
        WHERE user_id = ?;
    `;

    await new Promise((resolve, reject) => {
      connection.query(
        update_user_table,
        [new_doctor_name, doctor_age, results[0].user_id],
        (err, results) => {
          if (err) {
            console.log("Error updating doctor information in user table", err);
            reject(err);
          } else {
            console.log(
              "doctor information in user table updated successfully!"
            );
            resolve(results);
          }
        }
      );
    });

    callAdminView(res);
  } catch (error) {
    console.error(error);
  }
});

// -------------------------------------------------------------------------------------------------------------------

app.post("/admin/delete_doctor", async (req, res) => {
  const { doctor_id } = req.body;

  try {
    const get_user_id = `
    SELECT user_id FROM doctor WHERE doctor_id = ?;
  `;

    const results = await new Promise((resolve, reject) => {
      connection.query(get_user_id, [doctor_id], (err, results) => {
        if (err) {
          console.log("Error getting Doctor user_id", err);
          reject(err);
        } else {
          console.log("successfully got Doctor user_id!");
          resolve(results);
        }
      });
    });

    const deleteQuery = `DELETE FROM doctor WHERE doctor_id = ?;`;

    await new Promise((resolve, reject) => {
      connection.query(deleteQuery, [doctor_id], (err, results) => {
        if (err) {
          console.log("Error in deleting the doctor information", err);
          reject(err);
        } else {
          console.log("doctor information deleted successfully!");
          resolve(results);
        }
      });
    });

    const delete_user_row = `DELETE FROM user WHERE user_id = ?;`;

    await new Promise((resolve, reject) => {
      connection.query(delete_user_row, [doctor_id], (err, results) => {
        if (err) {
          console.log(
            "Error in deleting the doctor information in user table",
            err
          );
          reject(err);
        } else {
          console.log("doctor information in user table deleted successfully!");
          resolve(results);
        }
      });
    });

    callAdminView(res);
  } catch (error) {
    console.error(error);
  }
});

// --------------------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------

app.use(express.static(__dirname));

app.get("/", (req, res) => {
  res.sendFile(__dirname + "/views/index.html");
});

app.get("/log-in", (req, res) => {
  res.sendFile(__dirname + "/views/log-in.html");
});

app.get("/sign-up", (req, res) => {
  res.sendFile(__dirname + "/views/sign-up.html");
});

app.get("/disease_info", (req, res) => {
  const justSignedUp = req.session.justSignedUp || false;
  req.session.justSignedUp = false;
  const user_id = req.session.user_id || null;

  res.render("disease_info", { user_id, justSignedUp });
});

app.get("/post", (req, res) => {
  res.sendFile(__dirname + "/views/post.html");
});

app.get("/admin", (req, res) => {
  res.sendFile(__dirname + "/views/tables/admin_view.ejs");
});

app.set("view engine", "ejs");

// Start the server
app.listen(port, () => {
  console.log(`Server started on port ${port}`);
});
