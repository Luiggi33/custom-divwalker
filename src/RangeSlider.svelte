<script>
    export let id;
    export let min = 0;
    export let max = 100;
    export let step = 1;
    export let val = 50;
</script>
  
<div class="range">
    <input
        type="range"
        id="{id}"
        {min}
        {max}
        {step}
        name="{id}"
        bind:value={val}
    />
</div>

<style>
    :root {
        --range-size: 1rem;
        --range-colour: #2b7fff;
    }

    input[type="range"] {
        appearance: none;
        width: 100%;
        height: var(--range-size);
        color: var(--range-colour);
    }

    input[type="range"]:focus {
        outline: none;
    }

    input[type="range"]::-webkit-slider-thumb {
        -webkit-appearance: none;
        border: none;
        background-color: var(--range-colour);
        height: var(--range-size);
        width: var(--range-size);
    }

    input[type="range"]::-moz-range-thumb {
        border: none;
        background-color: var(--range-colour);
        height: var(--range-size);
        width: var(--range-size);
    }

    input[type="range"]::-ms-thumb {
        border: none;
        background-color: var(--range-colour);
        height: var(--range-size);
        width: var(--range-size);
    }

    input[type="range"]::-webkit-slider-runnable-track {
        background: transparent;
    }

    input[type="range"]::-moz-range-track {
        background: transparent;
    }

    input[type="range"]::-ms-track {
        background: transparent;
        border-color: transparent;
        color: transparent;
    }
</style>
