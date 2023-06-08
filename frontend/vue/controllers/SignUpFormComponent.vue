<template>
  <div v-if="submitted">
    <h2>Submission successful!</h2>
  </div>
  <FormKit type="form" @submit="submitHandler">
    <FormKit
        type="text"
        label="Your Email"
        name="email"
        prefix-icon="email"
        placeholder="email@domain.com"
        validation="required|email"
    />
    <FormKit
        type="text"
        label="First name"
        name="firstName"
        validation="required|length:1,100"
    />
    <FormKit
        type="text"
        label="Last name"
        name="lastName"
        validation="required|length:1,100"
    />
  </FormKit>
</template>

<script setup>
import {ref} from 'vue';

const submitted = ref(false);
const submitHandler = async (fields, node) => {
  let response = await fetch('/api/users', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json;charset=utf-8'
    },
    body: JSON.stringify(fields)
  });
  let result = await response.json();
  if (result.violations) {
    const errors = {};
    result.violations.forEach((error) => {
      errors[error.propertyPath] = error.message;
    });
    node.setErrors('', errors);
    submitted.value = false;
  } else {
    submitted.value = true;
  }
}
</script>
