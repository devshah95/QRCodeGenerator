import React, { useState } from "react"
import axios from "axios"
import "./styles.css" // Import the CSS file

function App() {
  const [input, setInput] = useState("")
  const [qrCode, setQrCode] = useState(null)

  const generateQrCode = () => {
    axios
      .post(
        "http://qr-code-backend:8000/generate_qr/", // Use the backend container name
        { data: input },
        { responseType: "blob" }
      )
      .then((response) => {
        const url = URL.createObjectURL(response.data)
        setQrCode(url)
      })
      .catch((error) => {
        console.error("Error generating QR code:", error)
      })
  }

  return (
    <div className="container">
      <h1>QR Code Generator</h1>
      <input
        type="text"
        value={input}
        placeholder="Enter URL or text"
        onChange={(e) => setInput(e.target.value)}
      />
      <button onClick={generateQrCode}>Generate QR Code</button>
      {qrCode && <img src={qrCode} alt="QR Code" />}
    </div>
  )
}

export default App
