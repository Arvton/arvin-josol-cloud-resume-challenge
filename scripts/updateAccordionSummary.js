// Get the details element
const detailsElement = document.querySelector('details');

// Get the summary element
const summaryElement = detailsElement.querySelector('summary');

// Add event listener to the details element
detailsElement.addEventListener('toggle', () => {
    // Check if the details element is open
    if (detailsElement.open) {
        // Clear the text content of the summary element
        summaryElement.innerText = 'Collapse to hide details';
    } else {
        // Set the text content of the summary element
        summaryElement.innerText = 'Expand to view details';
    }
});