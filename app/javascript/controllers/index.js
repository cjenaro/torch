// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import BlockController from "./block_controller"
application.register("block", BlockController)

import BlocksController from "./blocks_controller"
application.register("blocks", BlocksController)

import CollapsibleController from "./collapsible_controller"
application.register("collapsible", CollapsibleController)

import CommandController from "./command_controller"
application.register("command", CommandController)

import GreetingsController from "./greetings_controller"
application.register("greetings", GreetingsController)

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import SortableController from "./sortable_controller"
application.register("sortable", SortableController)
