use v5.42;
use feature 'class';
use utf8;                        
use open qw(:std :encoding(UTF-8));

  field $help_text = <<~EOF;
        Melo Package Manager (AGPL) - Edmilson Rodrigues@2026

        Usage:
          mpm [APPLICATION] [COMMAND] [ARGUMENTS] [FLAGS...]

        This is a package manager created for Building Linux From Scratch distributions.

        It is meant for both being able to package applications in order to be facilitate installation on the final system, managing dependencies, installed applications, remotions, and provide a standard installation command.

        APPLICATIONS:
            help              Show help for the commands stated after (Same as mpm command --help).
            package           Meant for managing the packages in your system.
            build             Meant for creating MELO packages based on the source (.melo).

        FLAGS:
            --quiet, -q       Do not print anything but warnings and errors.
            --verbose, -v     Prints more logging than usual.
            --help, -h        Show help for command (Same as mpm help command).
            --debug, -d       Prints extensive logging, including internal variables.
        EOF

  field $package_help_text = <<~EOF;
        Usage:
          mpm package [package-COMMAND] [ARGUMENTS] [FLAGS...]

        The application "package" is meant for use in regular package management for your system, such as installing, removing, getting info, upgrading, etc...

        COMMANDS:
            install           Installs a package or collection of packages.
            remove            Remove the installation of a package.
            update            Points to a source of packages, being via url, or local file system, and updates the cache of packages.
            upgrade           Upgrade a specific package or all packages based on the cache of packages.
            info              Shows info about the package, being either a installed one or one in the cache.
            changelog         Shows the changelog of a specific package, either installed or in the cache.
        EOF

  field $build_help_text = <<~EOF;
        Usage:
          mpm build [build-COMMAND] [ARGUMENTS] [FLAGS...]

        The application "build" is meant for building MELO packages from a source, and all related activities.

        COMMANDS:
            package           Builds a '.melo' package from the source files passed to it, or a '.melosrc' file, using a fake root system.
            source            Builds a '.melosrc' package from the source files passed. This kind of package isn't actually
                              a builded package, but, instead, a pre-packaged, meant to be built in the final system.
            lint              Lints the source files, in order to find possible bugs in the control files used to build the package.
        EOF
        

