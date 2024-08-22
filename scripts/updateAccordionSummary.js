const summaryLabels = {
    open: 'Collapse to hide details',
    closed: 'Expand to view details'
}

// code for military experience accordion. a listener looks for a toggle to change the text.
const militaryDetails = document.getElementById('military-details');
const militarySummary = document.getElementById('military-summary');

militaryDetails.addEventListener('toggle', () => {
    if (militaryDetails.open) {
        militarySummary.innerText = summaryLabels.open;
    } else {
        militarySummary.innerText = summaryLabels.closed;
    }
});