import express from "express"
import prisma from "@repo/db"

const app = express();
app.use(express.json());


app.post("/", async (req, res) => {
    const username = req.body.username;
    const password = req.body.password;
    const user = await prisma.user.create({
        data: {
            username: username,
            password: password
        }
    })
    res.json({
        message: "Signup successful",
        id: user.id
    })
})

app.listen(3000)
