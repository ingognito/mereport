
# GitHub Merge Report Tool

Scans through a github repository for merges, pull requests and commits and generates a merge report.

## Command-Line Options

### Login

    -l, --login LOGIN                GitHub LOGIN
    -p, --password PASSWORD          GitHub PASSWORD

Currently ony clear text login is supported.

### Repository

    -u, --user USER                  GitHub USER's repository
    -r, --repository REPOSITORY      GitHub REPOSITORY

You must specify user and repository.

### Constraints

    -R, --revisions SHA              GitHub SHA to start with

If not specified with the revision option scanning will start with the master commit. The programm will scan starting
from there down the history. For commits with several ancestors it will allways choose the *first* ancestor.

    -T, --target-revisions SHA       GitHub SHA to end with
    -s, --since TIME                 Show only commits prior to TIME

You can specify search depth by target revision and/or time. The search will stop at the target revision or at the last
commit prior to the specified time, whichever comes first.

### Flags

    -L, --links LINKS                scans for LINKS

If specified, the regex `LINKS` will be applied to any URL-like text. If matching, the link will be listed and opened
 in a browser if `-b` is specified.


    -m, --[no-]merge                 Show/don't show merge reports (default: on)
    -c, --[no-]commits               Show/don't show commits to master (default: on)
    -P, --[no-]pull                  Show/don't show pull requests (default: off)
    -a, --[no-]actions               Show/don't show actions  (default: off)
    -b, --[no-]browser               Open all links in new browser window. Only works under OS X.  (default: off)

Per default, the programm scans for all pull requests and all non-pull commits to master. You can switch both off.
Furthermore, you can activate listing of all pull requests.

On OS X you can request opening all relevant URL's in one browser window with the `b` option.

## Examples

Show all pull requests and commits to this master since 2012-08-08.

        ruby reporter.rb -l login -p pwd -u ingognito -r mereport -s 2012-08-08

Show all pull requests to this master since 2012-08-08. No commit messages.

        ruby reporter.rb -l login -p pwd -u ingognito -r mereport -s 2012-08-08 --no-commit

Only show the open pull requests:

        ruby reporter.rb -l login -p pwd -u ingognito -r mereport -s 2012-08-08 --no-commit --no-merge -P

Only show the open pull requests and open them in a browser window:

        ruby reporter.rb -l login -p pwd -u ingognito -r mereport -s 2012-08-08 --no-commit --no-merge -P -b

Show all and open lots of browser windows:

        ruby reporter.rb -l login -p pwd -u ingognito -r mereport -s 2012-08-08 -P -b
