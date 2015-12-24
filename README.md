# Dalligator

Delegate between a prioritized list of running programs by path.

## Functionality

Dalligator is a `bash` script for delegating between some equivalent programs and invoking the highest priority one with the provided arguments if any. If none of the delegated programs are currently running, it will launch the first one.

## Usage

`$ dalligator <delegated_program_path>... [with <delegated_argument>...]`

The programs have to be supplied via their process path, this is to allow delegation between different binaries of multiple processes with the same name, which is indeed my own personal use-case.

Any arguments provided after the `with` command will be supplied as is to the program being launched.

## Example

`$ dalligator /usr/lib/firefox/firefox "/home/scio/Portable Apps/Firefox_DE/firefox" with ddg.gg`

Opens DuckDuckGo on either my main Firefox instance, or the portable Developer Edition if it's running. And, more importantly, doesn't launch the main Firefox if the Developer Edition is already running on my memory-starved system.

I in fact use the command `dalligator /usr/lib/firefox/firefox "/home/scio/Portable Apps/Firefox_DE/firefox" with ` As my preferred browser configuration so that all links go through this delegation!
