<template>
  <form action="https://formspree.io/f/your-form-id" method="POST">
    <label>
      Spatial extent (Bounding box):<br />
      <input name="bbox" required />
    </label>
    <br /><br />
    <label>
      Start date<br />
      <input name="start_date" type = "date" required></input>
    </label>
    <br /><br />
    <button type="submit" class="VPButton medium brand">Submit job</button>
  </form>
</template>
