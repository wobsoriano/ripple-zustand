import { create } from '../src';
import { beforeEach, describe, expect, it, vi } from 'vitest';
import { flushSync, mount, trackAsync } from 'ripple';

type FetchState = {
	data: string | null;
	fetch: () => Promise<void>;
};

const useFetchStore = create<FetchState>((set) => ({
	data: null,
	fetch: async () => {
		await Promise.resolve();
		set({ data: 'loaded' });
	},
}));

const useErrorStore = create<{ fetch: () => Promise<void> }>(() => ({
	fetch: async () => {
		await Promise.resolve();
		throw new Error('fetch failed');
	},
}));

component AsyncItem() {
	const &[data] = trackAsync(async () => {
		await useFetchStore.getState().fetch();
		return useFetchStore.getState().data;
	});
	<p>{data}</p>
}

component AsyncApp() {
	try {
		<AsyncItem />
	} pending {
		<p>{'Loading...'}</p>
	} catch (e) {
		<p>{'Error!'}</p>
	}
}

component ErrorItem() {
	const &[data] = trackAsync<string>(async () => {
		await useErrorStore.getState().fetch();
		return '';
	});
	<p>{data}</p>
}

component ErrorApp() {
	try {
		<ErrorItem />
	} pending {
		<p>{'Loading...'}</p>
	} catch (e) {
		<p>{`Caught: ${e.message}`}</p>
	}
}

describe('async actions', () => {
	beforeEach(() => {
		useFetchStore.setState(useFetchStore.getInitialState(), true);
	});

	it('shows resolved state after async store action completes', async () => {
		const container = document.createElement('div');
		document.body.appendChild(container);

		mount(AsyncApp, { target: container });
		flushSync();

		await vi.waitFor(() => {
			expect(container.querySelector('p')?.textContent).toBe('loaded');
		});

		container.remove();
	});

	it('propagates async action errors to the catch boundary', async () => {
		const container = document.createElement('div');
		document.body.appendChild(container);

		mount(ErrorApp, { target: container });
		flushSync();

		await vi.waitFor(() => {
			expect(container.querySelector('p')?.textContent).toBe('Caught: fetch failed');
		});

		container.remove();
	});
});
