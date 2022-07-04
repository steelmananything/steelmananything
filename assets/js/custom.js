try {
  // https://stackoverflow.com/a/70062967
  window.addEventListener('beforeprint', () => {
    const allDetails = document.body.querySelectorAll('details');
    for (let i = 0; i < allDetails.length; i++) {
      if (allDetails[i].open) {
        allDetails[i].dataset.open = '1';
      } else {
        allDetails[i].setAttribute('open', '');
      }
    }
  });

  window.addEventListener('afterprint', () => {
    const allDetails = document.body.querySelectorAll('details');
    for (let i = 0; i < allDetails.length; i++) {
      if (allDetails[i].dataset.open) {
        allDetails[i].dataset.open = '';
      } else {
        allDetails[i].removeAttribute('open');
      }
    }
  });

  if (window.location.search.search(/[?&]expand/) !== -1) {
    const allDetails = document.body.querySelectorAll('details');
    for (let i = 0; i < allDetails.length; i++) {
      allDetails[i].setAttribute('open', '');
    }
  }
} catch (e) {
  console.log(e);
}
