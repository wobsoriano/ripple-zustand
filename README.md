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

## Recipes

### Fetching everything

```ts
const state = useStore()
```

### Selecting multiple state slices

```ts
const nuts = useStore(state => state.nuts)
const honey = useStore(state => state.honey)
```

### Async actions

```ts
const useTodoStore = create((set) => ({
  todo: {},
  fetch: async (todoId) => {
    const response = await fetch(`https://dummyjson.com/todos/${todoId}`)
    set({ todo: await response.json() })
  },
}))

export component App() {
	try {
		<TodoItem />
	} pending {
		<p>{'Loading...'}</p>
	}
}

component TodoItem(props) {
  const todoStore = useTodoStore()
  await todoStore.fetch(props.id)

  <li>{todoStore.@todo.todo}</li>
}
```
