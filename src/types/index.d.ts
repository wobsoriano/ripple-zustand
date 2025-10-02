import { ExtractState, StoreApi, StoreMutatorIdentifier, StateCreator, Mutate } from 'zustand/vanilla';
import { Tracked } from 'ripple';

type ReadonlyStoreApi<T> = Pick<
  StoreApi<T>,
  'getState' | 'getInitialState' | 'subscribe'
>
type IsFunction<T> = T extends (...args: any[]) => any ? T : never;
declare function useStore<S extends StoreApi<unknown>>(api: S): ExtractState<S>;
declare function useStore<S extends StoreApi<unknown>, U>(api: S, selector: (state: ExtractState<S>) => U): U;
type UseBoundStore<S extends ReadonlyStoreApi<unknown>> = {
  (): ExtractState<S> extends IsFunction<ExtractState<S>> ? ExtractState<S> : Tracked<ExtractState<S>>;
  <U>(selector: (state: ExtractState<S>) => U): U extends IsFunction<U> ? U : Tracked<U>;
} & S
interface Create {
  <T, Mos extends [StoreMutatorIdentifier, unknown][] = []>(
    initializer: StateCreator<T, [], Mos>,
  ): UseBoundStore<Mutate<StoreApi<T>, Mos>>
  <T>(): <Mos extends [StoreMutatorIdentifier, unknown][] = []>(
    initializer: StateCreator<T, [], Mos>,
  ) => UseBoundStore<Mutate<StoreApi<T>, Mos>>
}
declare const create: Create;

export { create, useStore };
