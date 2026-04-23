import { defineConfig } from 'tsdown';

export default defineConfig({
	dts: true,
	entry: ['src/index.ts'],
	target: 'es2020',
	format: 'esm',
	minify: true,
});
