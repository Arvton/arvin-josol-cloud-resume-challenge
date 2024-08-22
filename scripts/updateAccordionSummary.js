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

// code for cloud resume accordion. a listener looks for a toggle to change the text.
const cloudResumeDetails = document.getElementById('cloud-resume-details');
const cloudResumeSummary = document.getElementById('cloud-resume-summary');

cloudResumeDetails.addEventListener('toggle', () => {
    if (cloudResumeDetails.open) {
        cloudResumeSummary.innerText = summaryLabels.open;
    } else {
        cloudResumeSummary.innerText = summaryLabels.closed;
    }
});

// code for mini paint challenge accordion. a listener looks for a toggle to change the text.
const miniPaintChallengeDetails = document.getElementById('mini-paint-challenge-details');
const miniPaintChallengeSummary = document.getElementById('mini-paint-challenge-summary');

miniPaintChallengeDetails.addEventListener('toggle', () => {
    if (miniPaintChallengeDetails.open) {
        miniPaintChallengeSummary.innerText = summaryLabels.open;
    } else {
        miniPaintChallengeSummary.innerText = summaryLabels.closed;
    }
});