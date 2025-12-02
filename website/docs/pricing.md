# Pricing

This project is creating free and open-source software under the MIT license.
There are plenty of ways to run the workflow locally after downloading the [data](/background-gfm.html#data).
However, the workflow can be also be executed with [openEO at EODC](https://editor.openeo.org/?server=openeo.eodc.eu%2Fopeneo%2F1.2.0%2F) by enabling experimental processes and searching for 'rqadeforestation'.
A preliminary price estimation can be calculated using the following tool:

## openEO price calculator

<div>

<!-- added HTML form + script -->
<form id="pricing-form" onsubmit="return false;" style="margin-top:1rem;">
  <label>
    Equi7 tiles:
    <input id="tiles" type="number" min="0" step="1" value="1" style="width:6rem;">
  </label>
  <br style="line-height:0.6;">
  <label>
    Start date:
    <input id="start" type="date">
  </label>
  <label style="margin-left:1rem;">
    End date:
    <input id="end" type="date">
  </label>
  <div style="margin-top:0.5rem;">
    Price: <output id="price">0.00</output>
  </div>
</form>

<script>
(function(){
  const tilesEl = document.getElementById('tiles');
  const startEl = document.getElementById('start');
  const endEl = document.getElementById('end');
  const priceEl = document.getElementById('price');

  const minDate = '2014-01-01';
  const today = new Date();
  const yyyy = today.getFullYear();
  const mm = String(today.getMonth()+1).padStart(2,'0');
  const dd = String(today.getDate()).padStart(2,'0');
  const todayStr = `${yyyy}-${mm}-${dd}`;

  startEl.min = minDate;
  endEl.min = minDate;
  startEl.max = todayStr;
  endEl.max = todayStr;

  startEl.value = minDate;
  endEl.value = todayStr;

  function parseDateInput(el){
    const v = el.value;
    if(!v) return null;
    const d = new Date(v + 'T00:00:00Z');
    return isNaN(d) ? null : d;
  }

  function compute(){
    const tiles = Number(tilesEl.value) || 0;
    const start = parseDateInput(startEl);
    const end = parseDateInput(endEl);
    if(!start || !end || end < start){
      priceEl.textContent = '0.00';
      return;
    }
    // duration in years (approx)
    const msPerYear = 1000 * 60 * 60 * 24 * 365.25;
    const years = (end - start) / msPerYear;
    const product = tiles * years;
    priceEl.textContent = product.toFixed(2);
  }

  tilesEl.addEventListener('input', compute);
  startEl.addEventListener('change', compute);
  endEl.addEventListener('change', compute);

  // initial compute
  compute();
})();
</script>
</div>