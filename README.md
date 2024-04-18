# George Brown College (GBC) Calendar Importer

As a student at George Brown College, I found it annoying to enter all of my classes into my calendar manually. This script takes the input from the "Detailed Schedule" view in STU-VIEW and generates a `.ics` file that can be imported into any calendar application.

## Usage

Example: `bin/gbc-calendar -i schedule.txt -o my-courses.ics`

```bash
GBC Calendar Importer 0.0.1

USAGE:
gbc-calendar [options]

OPTIONS:
    -i, --input FILENAME             The file to parse
    -o, --output FILENAME            The file to send output to
    -v, --verbose                    Show extra information
    -h, --help                       Show this message
        --version                    Show version
```

## Installation

This script is written in Ruby, you can check if it's installed with:

```bash
ruby -v
```

If it's not installed, you can install it using the documentation on the [official Ruby website](https://www.ruby-lang.org/en/documentation/installation/).

Once Ruby is intalled, download this repo and run the script `bin/gbc-calendar`.

## How to get the detailed schedule

1. Go to STU-VIEW and log in.
2. Click on "Registration Services -> Registration -> View Detailed Course Schedule".
3. Cmd+A to select all, Cmd+C to copy.
4. Paste the contents into a file called `schedule.txt`.

## How to import the calendar

On most operating systems you can import the `.ics` file by double-clicking on it. If that doesn't work, you can try the following:

### Google Calendar

1. Go to [Google Calendar](https://calendar.google.com).
2. Click on the gear icon in the top right corner.
3. Click on "Settings".
4. Click on "Import & export".
5. Click on "Select file from your computer" and select the `.ics` file.

### Apple Calendar

1. Open the Calendar app.
2. Click on "File -> Import".
3. Select the `.ics` file.

## Development Notes

- Currently, the bulk of the code is in `src` with the CLI options
  in `bin`.
- I am experimenting with generating a binary using WASM that can
  be distributed instead of needing to download the whole repo.
- I am also experimenting with using a web interface to upload the
  schedule data and download an `.ics` file.
- A subsequent improvement would be to have hosted calendar
  subscriptions, so students only need to subscribe to the calendar
  once and periodically upload their schedules.

