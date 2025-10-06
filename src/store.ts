import { create } from './lib/useStore.ripple';

interface BearState {
	bears: number;
	increase: () => void;
	decrease: () => void;
}

export const useStore = create<BearState>((set) => ({
	bears: 0,
	increase: () => set((state) => ({ bears: state.bears + 1 })),
	decrease: () => set((state) => ({ bears: state.bears - 1 })),
}));

interface Todo {
	id: number;
	todo: string;
}

interface TodoState {
	todo: null | Todo;
	fetch: (todoId: number) => Promise<void>;
}

export const useTodoStore = create<TodoState>((set) => ({
	todo: null,
	fetch: async (todoId) => {
		const response = await fetch(`https://dummyjson.com/todos/${todoId}`);
		set({ todo: (await response.json()) as Todo });
	},
}));
