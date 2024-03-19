const visitorCount = document.getElementById('visitor-count');

// Get the current count from the database
fetch("https://func-crc-aj-tech.azurewebsites.net/api/posthttptrigger", { method: 'POST' })
    .then(response => response.json())
    .then(data => {
        visitorCount.innerHTML = data.Count;
    })
    .catch(error => console.error('Error:', error));