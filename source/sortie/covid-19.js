function $(id) { return document.getElementById(id); }
var is_safari = /^((?!chrome|android).)*safari/i.test(navigator.userAgent);
var timeMin = 1000*60;
var offset = new Date().getTimezoneOffset();

if (is_safari) {
  $('date').value = new Date().toLocaleDateString('fr-FR');
} else {
  $('date').valueAsDate = new Date();
  $('date-time').valueAsNumber = Math.floor(new Date().getTime()/timeMin)*timeMin - offset*timeMin;
}

// CANVAS HANDLING

var canvas = $('signature');
canvas.addEventListener('mousedown', ev_mousedown, false);
canvas.addEventListener('mousemove', ev_mousemove, false);
window.addEventListener('mouseup', ev_mouseup, false);

canvas.addEventListener('touchstart', ev_touchstart, false);
canvas.addEventListener('touchmove', ev_touchmove, false);
window.addEventListener('touchend', ev_mouseup, false);

ctx = canvas.getContext('2d');

var started = false;

function ev_mouseup(ev) {
  started = false;
}

function ev_touchstart(ev) {
  ev.preventDefault();
  started = true;
  var rect = canvas.getBoundingClientRect();
  var x = ev.touches[0].clientX;
  var y = ev.touches[0].clientY;
  x = x - rect.left;
  y = y - rect.top;

  ctx.beginPath();
  ctx.moveTo(x, y);
}

function ev_touchmove(ev) {
  ev.preventDefault();
  var rect = canvas.getBoundingClientRect();
  var x = ev.touches[0].clientX;
  var y = ev.touches[0].clientY;
  x = x - rect.left;
  y = y - rect.top;

  if (started) {
    ctx.lineTo(x, y);
    ctx.stroke();
  }
}

function ev_mousedown(ev) {
  started = true;
  ctx.beginPath();
  ctx.moveTo(ev.offsetX, ev.offsetY);
}

function ev_mousemove(ev) {
  if (started) {
    ctx.lineTo(ev.offsetX, ev.offsetY);
    ctx.stroke();
  }
}

function can_clear() {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  return false;
}

// RENDERING

function render() {
  canvas.removeEventListener('mousedown', ev_mousedown);
  canvas.style.cssText = "border: none;";

  $("clear_btn").remove();
  $("render_btn").remove();

  var date = $('date').valueAsDate.toLocaleDateString('fr-FR');
  var born = $('born').valueAsDate.toLocaleDateString('fr-FR');
  var formatter = new Intl.DateTimeFormat("fr-FR", {hour: "numeric", minute: "numeric"});
  var time = formatter.format(new Date($('date-time').valueAsDate.getTime() + $('date-time').valueAsDate.getTimezoneOffset()*60*1000));
  var to_disable = ['choix_a', 'choix_b', 'choix_c', 'choix_d', 'choix_e', 'choix_f', 'choix_g'];

  var motifs = to_disable.reduce(function(acc, el) {
    if ($(el).checked) {
      return acc.concat([$(el).value]);
    } else {
      return acc;
    }
  }, []).join('-');
  var qrCodeText = "Cree le: " + date + " a " + time + "; Nom: " + $('name').value.split(" ")[1] + "; Prenom: " + $('name').value.split(" ")[0] + "; Naissance: " + born + " a " + $('where').value + "; Adresse: " + $('address').value + "; Sortie: " + date + " a " + time + "; Motifs: " + motifs;

  QRCode.toCanvas(
    $('qrcode'),
    qrCodeText,
    function (error) {
      if (error) console.error(error);
      console.log('QR code generated with success!');
    }
  );

  var to_render = ['name', 'where', 'address', 'place'];
  to_render.forEach(function(el) {
    $(el).insertAdjacentHTML('afterend', $(el).value);
    $(el).remove();
  });
  $('born').insertAdjacentHTML('afterend', born);
  $('born').remove();
  $('date').insertAdjacentHTML('afterend', date);
  $('date').remove();
  $('date-time').insertAdjacentHTML('afterend', time);
  $('date-time').remove();

  to_disable.forEach(function(el) {
    if (!$(el).checked) {
      $(el).remove();
      $('label_' + el).remove();
    }
  });

  window.print();
}
