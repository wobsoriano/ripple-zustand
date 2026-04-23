import { create } from '../src';
import { beforeEach, describe, expect, it } from 'vitest';
import { flushSync, mount } from 'ripple';

const useStore = create<
	{
		count: number;
		increase: () => void;
	}
>(
	(set) => ({
		count: 0,
		increase: () => set((state) => ({ count: state.count + 1 })),
	}),
);

component Counter() {
	const &[count] = useStore((state) => state.count);
	<h1>{`Count: ${count}`}</h1>
}

component Controls() {
	const increase = useStore((state) => state.increase);
	<button onClick={increase}>{'one up'}</button>
}

component App() {
	<Counter />
	<Controls />
}

describe('create', () => {
	describe('composable', () => {
		beforeEach(() => {
			useStore.setState(useStore.getInitialState(), true);
		});

		it('returns default zustand properties', () => {
			expect(typeof useStore.setState).toBe('function');
			expect(typeof useStore.getState).toBe('function');
			expect(typeof useStore.subscribe).toBe('function');
		});

		it('functions correct when rendered in Ripple', async () => {
			const container = document.createElement('div');
			document.body.appendChild(container);

			mount(App, {
				target: container,
			});
			flushSync();

			expect(container.querySelector('h1').textContent).toBe('Count: 0');

			const button = container.querySelector('button');

			button.click();
			flushSync();

			expect(container.querySelector('h1').textContent).toBe('Count: 1');
		});

		it('updates components when setState is called externally', () => {
			const container = document.createElement('div');
			document.body.appendChild(container);

			mount(App, { target: container });
			flushSync();

			expect(container.querySelector('h1').textContent).toBe('Count: 0');

			useStore.setState({ count: 42 });
			flushSync();

			expect(container.querySelector('h1').textContent).toBe('Count: 42');
		});

		it('only re-renders the slice that changed', () => {
			const useSplitStore = create<{
				a: number;
				b: number;
				incA: () => void;
			}>((set) => ({
				a: 0,
				b: 0,
				incA: () => set((s) => ({ a: s.a + 1 })),
			}));

			component SliceA() {
				const &[a] = useSplitStore((s) => s.a);
				<span id="a">{`a:${a}`}</span>
			}

			component SliceB() {
				const &[b] = useSplitStore((s) => s.b);
				<span id="b">{`b:${b}`}</span>
			}

			component SplitApp() {
				<SliceA />
				<SliceB />
			}

			const container = document.createElement('div');
			document.body.appendChild(container);

			mount(SplitApp, { target: container });
			flushSync();

			expect(container.querySelector('#a').textContent).toBe('a:0');
			expect(container.querySelector('#b').textContent).toBe('b:0');

			useSplitStore.getState().incA();
			flushSync();

			// a updates, b stays unchanged
			expect(container.querySelector('#a').textContent).toBe('a:1');
			expect(container.querySelector('#b').textContent).toBe('b:0');
		});
	});
});
