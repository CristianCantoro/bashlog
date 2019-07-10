bashlog
-------

bashlog is a small collection of bash functions - you may call it a one-file library - to help you with logging in your scripts.

## Phylosophy

bashlog is inspired by the [logging](https://docs.python.org/3/library/logging.html#module-logging) module in Python. However there are a number of differences due to the difference nature between Bash and Python scripting. bashlog will use the same terminology as the `logging` module, so you may want to take a look to the documentation of the module for clarification.

bashlog handles the possibility to log to multiple files and logging both to different channels (files and standard error), however you don't have as much freedom as you have with Python, some differences are:

 - each logger always writes to two channels: the file specified when creating the logger and standard error. The idea is that the logfile is the main channel and standard error is there as an extra for debugging. For this reason by default you can set a `logger_loglevel` that will save to file only the message that have a loglevel equal or higher of it, but everything is written to standard error. With Python you can add as many channels as you want to a logger; the logger has its own `loglevel` so as each channel, thus you have a much more fine-grained control of which messages are printed.
 - each logger can write to only one file, however multiple loggers can write to the same file. As said in the previous point, the `logging`Python module allows you to attach as many channel as you want to the same logger.
 - you can only choose one format that is applied to both the file and the standard error channels. With the logging module you can customize each channel output format.

 It possibile to create a logger that logs only to file by setting its verbosity level to `donotlog`. In the same way it is possible to create a logger that logs only to standard output by setting the logger loglevel to `donotlog`.

### Loglevels

The loglevels understood by bashlog are the following, with their correspond value:

| value | loglevel |
|-------|----------|
| 0     | notset   |
| 10    | debug    |
| 20    | info     |
| 30    | warning  |
| 40    | error    |
| 50    | critical |
| 100   | donotlog |

## Functions

Upon being sourced, bashlog provides just one function that can be used to create and customize yout loggers:

* `start_logging [-f <format>] [-v <verbosity_level>] [-l logger_loglevel] <logfile> <logger>`: sets up logging to `logfile`. You should use it at the beginning of your scripts. As optional arguments you can specify:
    - `-f <format>`, a string specifing the log format. The default is `'"[" strftime("%Y-%m-%d %H:%M:%S") "][__loglevel__]:\t__msg__"'` that prints messages like this: `[YYYY-mm-dd HH:MM:SS][<loglevel>]:    <msg>`. You can use two _magic words_ for the format:
        - `__loglevel__`: the log level of the message being logged. It can be one of `debug`, `info`, `warning`, `error`, `critical`;
        - `__msg__`: the message being logged.
    - `-v <verbosity_level>`, this settings controls which messages are logged to standard error. `verbosity_level` can be one of `notset`, `debug`, `info`, `warning`, `error`, `critical`, or `donotlog`. Message are printed to standard error if their log level is equal or higher to the verbosity level set by this option (see the "Loglevels" section above for reference). By default it is set to `notset`, which prints all messages.
    - `-l <logger_loglevel>`, this settings controls which messages are logged to the logfile. `logger_loglevel` can be one of `notset`, `debug`, `info`, `warning`, `error`, `critical`, or `donotlog`. Message are printed to the logfile if their log level is equal or higher to the verbosity level set by this option (see the "Loglevels" section above for reference). By default it is set to `notset`, which prints all messages.

### Loggers

If you create a logger with `start_logging <logfile> <logger>`, five functions are created:
* `<logger>_debug`
* `<logger>_info`
* `<logger>_warning`
* `<logger>_error`
* `<logger>_critical`

where `<logger>` is the log name.

Calling `<logger>_<loglevel> <message>` logs `<message>` with loglevel `<loglevel>`. You can also feed a pipe to a logger: `echo "$msg" | <logger>_<loglevel>`.

## Examples

### Basic usage
```bash
source "<yourpath>/bashlog/log.sh"

# creates a logger called mylogger
start_logging 'test.log' 'mylogger'

# logs a message
mylogger_debug 'This is a DEBUG log message'
mylogger_info 'This is a INFO log message'

# logs the output of command
date | mylogger_info
```
