# ripple-zustand

A small, fast, and scalable bearbones state management for Ripple based on [Zustand](https://docs.pmnd.rs/).

## Installation

```bash
npm install zustand ripple-zustand
```

## Usage

### First create a store

Your store is a function! You can put anything in it: primitives, objects, functions. The `set` function merges state.

```ts
import { create } from 'ripple-zustand'

const useBear = create((set) => ({
  bears: 0,
  increasePopulation: () => set((state) => ({ bears: state.bears + 1 })),
  removeAllBears: () => set({ bears: 0 }),
  updateBears: (newBears) => set({ bears: newBears }),
}))
```

### Then bind your components, and that's it!

Use the function anywhere, no providers are needed.

```tsx
component BearCounter() {
    const bears = useBear((state) => state.bears)
    <h1>{`${@bears} bears around here...`}</h1>
}

component Controls() {
    const increasePopulation = useBear((state) => state.increasePopulation)
    <button onClick={increasePopulation}>{'one up'}</button>
}
```
