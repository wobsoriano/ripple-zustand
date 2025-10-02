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
