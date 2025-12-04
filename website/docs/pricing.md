# Pricing

This project is creating free and open-source software under the MIT license.
There are plenty of ways to run the workflow locally after downloading the [data](/background-gfm.html#data).
However, the workflow can be also be executed with [openEO at EODC](https://editor.openeo.org/?server=openeo.eodc.eu%2Fopeneo%2F1.2.0%2F) by enabling experimental processes and searching for 'rqadeforestation'.

## Price calculator

Please enter the spatio-temporal extent to be processed.
The price will be estimated automatically.

Ressource estimation were based on the following assumptions:

- Sentinel-1 Sigma0 collection at 20m resolution in Equi7 projection
- Satellite revisit period of 6 days, e.g., coverage in Europe
- data is available in GeoTIFF format
- files are located on a network share in the same data center
- execution on a  AMD EPIC MILAN CPU with 32GB RAM
- execution of the Julia package within a REPL

<ClientOnly>

<form @submit.prevent="onSubmit" class="form-horizontal">
  <div class="form-floating">
    <label for="start">Start date</label><br />
    <input id="start" type="date" v-model="start" class="form-control" value="01/01/2024" required />
  </div>

  <div class="form-floating">
    <label for="end">End date</label><br />
    <!-- enforce end >= start on the client -->
    <input id="end" type="date" v-model="end" :min="start" class="form-control" required />
  </div>

  <div class="form-floating">
    <label for="n_tiles">Number of Equi7 tiles</label><br />
    <input
      id="n_tiles"
      type="number"
      v-model.number="n_tiles"
      min="1"
      step="1"
      inputmode="numeric"
      class="form-control"
      required
    />
  </div>

  <div v-if="error" style="color:#b00020;margin-top:0.4rem">{{ error }}</div>

  <strong>Estimated runtime: {{ price }} min</strong>
</form>
</ClientOnly>

<div class = "alert alert-warning">
Please note that these results are not official offerings from any cloud provider.
Estimates may vary depend on the area of interest, orbits to be analysed, and execution platform.
</div>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'

const start = ref('')
const end = ref('')
const n_tiles = ref(1)
const submitted = ref(false)
const error = ref('')
let price = 0

const valid = computed(() => {
  if (!start.value || !end.value) return false
  if (start.value > end.value) return false
  if (!Number.isInteger(n_tiles.value) || n_tiles.value < 0) return false
  return true
})

watch([start, end, n_tiles], () => {
  error.value = ""
  if (start.value && end.value && start.value > end.value) {
    error.value = "Start date must be on or before end date."
  }
  if (Date.parse(start.value) < Date.parse("2014-10-01")) {
    error.value = "Data only available after Oct 2014"
  }
  if (!Number.isInteger(n_tiles.value)) {
    error.value = "Count must be an integer."
  }


  const satellite_revisit_days = 6
  const runtime_per_tile = 0.12
  let duration_days = (Date.parse(end.value) - Date.parse(start.value)) * 1e-3 / 60 / 60 / 24
  let satellite_time_steps = duration_days / satellite_revisit_days
  
  price = n_tiles.value * (satellite_time_steps^2) * runtime_per_tile
  price = Math.round(price * 10) / 10
})

onMounted(() => {
  start.value = "2022-01-01"
  end.value = "2023-01-01"
})
</script> 