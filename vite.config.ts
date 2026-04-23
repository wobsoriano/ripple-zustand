import { ripple } from '@ripple-ts/vite-plugin';
import { defineConfig } from 'vitest/config';

export default defineConfig({
	plugins: [ripple({ excludeRippleExternalModules: true })],
	resolve: process.env.VITEST ? { conditions: ['browser'] } : undefined,
	test: {
		include: ['tests/*.test.ts', 'tests/*.test.tsrx'],
		environment: 'jsdom',
	},
});
