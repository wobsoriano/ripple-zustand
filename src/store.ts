import { create } from './lib/useStore.ripple'

interface BearState {
  bears: number
  increase: () => void
}

export const useStore = create(set => ({
  bears: 0,
  increase: () => set(state => ({ bears: state.bears + 1 })),
  decrease: () => set(state => ({ bears: state.bears - 1 })),
}))

export const useTodoStore = create((set) => ({
  todo: {},
  fetch: async (todoId) => {
    const response = await fetch(`https://dummyjson.com/todos/${todoId}`)
    set({ todo: await response.json() })
  },
}))
