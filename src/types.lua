--!strict
-- types.lua
-- Type definitions for public Glue API

--> Component

export type ComponentFragment = {
	instance: Instance,

	OnInit: (() -> ())?,
	OnStart: (() -> ())?,
	OnDestroy: (() -> ())?,
}

export type Component = {
	createFragment: (Instance) -> ComponentFragment,
	getFragment: (Instance) -> ComponentFragment?,
	getFragments: () -> { [Instance]: ComponentFragment },
}

export type Components = {
	Start: (Components) -> (),
	extend: (Components, Tag: string) -> Component,
	getComponent: (Tag: string) -> Component?,
	getComponentFragment: (Tag: string, Instance) -> ComponentFragment?,
}

--> Networking

--[=[
    @type Middleware (Next: (...any) -> (), ...) -> (...any)
    @within Network
]=]
export type Middleware = ((...any) -> (...any))

export type NetworkEvent = {
	Fire: ((NetworkEvent, ...any) -> ()) & ((NetworkEvent, player: Player, ...any) -> ()),
	FireAll: (NetworkEvent, ...any) -> (),
	OnEvent: (NetworkEvent, ...Middleware) -> (),
}

export type NetworkFunction = {
	Invoke: ((NetworkFunction, ...any) -> ...any) & ((NetworkFunction, player: Player, ...any) -> ...any),
	OnInvoke: (NetworkFunction, ...Middleware) -> (),
}

export type Network = {
	Event: (Name: string) -> NetworkEvent,
	Function: (Name: string) -> NetworkFunction,
	fromRemote: ((RemoteEvent) -> NetworkEvent) & ((RemoteFunction) -> NetworkFunction),
}

--> State

export type Map<T> = { [string]: T }
export type Array<T> = { T }


--> Provider

--[=[
	@interface Provider
	@within Glue
	.Name string

	.onConfig: ((Provider, bindTo: (string) -> (), createBinding: () -> ()) -> ())?,
	.onCreate ((Provider) -> ())?
	.onStart ((Provider) -> ())?
	.onTick ((Provider) -> ())?
	.onRender ((Provider) -> ())?
]=]

export type Provider = {
	Name: string,

	onConfig: ((Provider, bindTo: (string) -> (), createBinding: () -> ()) -> ())?,
	onCreate: ((Provider) -> ())?,
	onStart: ((Provider) -> ())?,

	onTick: ((Provider, DeltaTime: number) -> ())?,
	onRender: ((Provider, DeltaTime: number) -> ())?,
}

export type ProviderDefinition = {
	Name: string,
	[string]: any
}

--> Math

export type Math = {
	Int: (x: number) -> number,
	Sum: (...number) -> number,
	Mean: (...number) -> number,
	IsInt: (x: number) -> boolean,
	Lerp: (a: number, b: number, t: number) -> number,
	Gaussian: (Mean: number, Variance: number) -> number,
	SlopeVec2: (P0: Vector2, P1: Vector2) -> number,
	SlopeVec3: (P0: Vector3, P1: Vector3) -> number,
	Magnitude: (P0: Vector2 | Vector3, P1: Vector2 | Vector3) -> number,
	Direction: (P0: Vector2 | Vector3, P1: Vector2 | Vector3) -> Vector2 | Vector3,
	SmoothStep: (a: number, b: number, t: number) -> number,
	InverseLerp: (a: number, b: number, v: number) -> number,
	SmootherStep: (a: number, b: number, t: number) -> number,
}

export type Glue = {
	Math: Math,
	Version: string,
	LocalPlayer: Player,
	Network: Network,
	Stick: () -> any,
	OnStick: () -> any,
	GetProvider: (Name: string) -> Provider?,
	Import: (Target: string | ModuleScript) -> any,
	loader: (Target: Instance, Seperator: string?) -> ((Path: string) -> any),
	Provider: <T>(ProviderDefinition: T) -> Provider & T,
	Extensions: (Extensions: { [string]: ((Provider) -> ()) }) -> (),
	Imports: (Paths: { Instance } | Instance) -> (),
}

return 1
