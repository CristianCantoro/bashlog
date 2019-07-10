bashlog
-------

bashlog is a small collection of bash functions - you may call it a one-file
library - to help you with logging in your scripts.


## Functions

* `start_logging [-f <format>] [-v <verbosity_level>] [-l logger_loglevel] <logfile> <logger>`: sets up logging to `logfile`. You should use it at the beginning of your scripts. As optional arguments you can specify:
	- `-f <format>`, a string specifing the log format

 If `verbose` is _true_ then messages are printed to standard output as well as on `logfile`. This function creates a new logger - which is a new bash function - with name `logger`.

* `LOGGER <message>`: logs `message` to `logfile`. You can also feed a pipe to a logger: `echo "$msg" | LOGGER`.

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