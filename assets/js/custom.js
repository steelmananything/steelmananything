try {

  if (window.location.search.search(/[?&]anchorroot/) !== -1) {
    var anchors = document.getElementsByTagName("a");
    let u = new URL(window.location);
    let urlbase = u.protocol + "//" + u.host;
    for (var i = 0; i < anchors.length; i++) {
      if (anchors[i].href.indexOf("anchorroot") != -1 && anchors[i].href.indexOf("#") != -1) {
        let newurl = urlbase + anchors[i].href.substring(anchors[i].href.indexOf("anchorroot") + 11);
        anchors[i].href = newurl;
      }
    }
  }

  /*
  if (window.location.search.search(/[?&]expand/) !== -1) {
    const allDetails = document.body.querySelectorAll('details');
    for (let i = 0; i < allDetails.length; i++) {
      allDetails[i].setAttribute('open', '');
    }
  }
  */

  /*
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
  */
} catch (e) {
  console.log(e);
}
