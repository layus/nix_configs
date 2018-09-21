{ config, lib, pkgs, serverInfo, php, ... }:

with lib;

let

  httpd = serverInfo.serverConfig.package;

  # Unpack Mediawiki and put the config file in its root directory.
  /*
  mediawikiRoot = pkgs.stdenv.mkDerivation rec {
    name= "mediawiki-1.23.9";

    src = pkgs.fetchurl {
      url = "http://download.wikimedia.org/mediawiki/1.23/${name}.tar.gz";
      sha256 = "1l7k4g0pgz92yvrfr52w26x740s4362v0gc95pk0i30vn2sp5bql";
    };

    skins = config.skins;

    buildPhase =
      ''
        for skin in $skins; do
          cp -prvd $skin/* skins/
        done
      '';

    installPhase =
      ''
        mkdir -p $out
        cp -r * $out
        cp ${mediawikiConfig} $out/LocalSettings.php
        sed -i \
        -e 's|/bin/bash|${pkgs.bash}/bin/bash|g' \
        -e 's|/usr/bin/timeout|${pkgs.coreutils}/bin/timeout|g' \
          $out/includes/limit.sh \
          $out/includes/GlobalFunctions.php
      '';
  };
  */

in

{

  /*
  extraConfig =
    ''
      ${optionalString config.enableUploads ''
        Alias ${config.urlPrefix}/images ${config.uploadDir}

        <Directory ${config.uploadDir}>
            ${allGranted}
            Options -Indexes
        </Directory>
      ''}

      ${if config.urlPrefix != "" then "Alias ${config.urlPrefix} ${mediawikiRoot}" else ''
        RewriteEngine On
        RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-f
        RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-d
        ${concatMapStringsSep "\n" (u: "RewriteCond %{REQUEST_URI} !^${u.urlPath}") serverInfo.vhostConfig.servedDirs}
        ${concatMapStringsSep "\n" (u: "RewriteCond %{REQUEST_URI} !^${u.urlPath}") serverInfo.vhostConfig.servedFiles}
        RewriteRule ${if config.enableUploads
          then "!^/images"
          else "^.*\$"
        } %{DOCUMENT_ROOT}/${if config.articleUrlPrefix == ""
          then ""
          else "${config.articleUrlPrefix}/"
        }index.php [L]
      ''}

      <Directory ${mediawikiRoot}>
          ${allGranted}
          DirectoryIndex index.php
      </Directory>

      ${optionalString (config.articleUrlPrefix != "") ''
        Alias ${config.articleUrlPrefix} ${mediawikiRoot}/index.php
      ''}
    '';
  */

  documentRoot = ""; #if config.urlPrefix == "" then mediawikiRoot else null;

  enablePHP = true;

  options = {

    id = mkOption {
      default = "main";
      description = ''
        A unique identifier necessary to keep multiple MediaWiki server
        instances on the same machine apart.  This is used to
        disambiguate the administrative scripts, which get names like
        mediawiki-$id-change-password.
      '';
    };

    dbType = mkOption {
      default = "postgres";
      example = "mysql";
      description = "Database type.";
    };

    dbName = mkOption {
      default = "mediawiki";
      description = "Name of the database that holds the MediaWiki data.";
    };

    dbServer = mkOption {
      default = ""; # use a Unix domain socket
      example = "10.0.2.2";
      description = ''
        The location of the database server.  Leave empty to use a
        database server running on the same machine through a Unix
        domain socket.
      '';
    };

    dbUser = mkOption {
      default = "mediawiki";
      description = "The user name for accessing the database.";
    };

    dbPassword = mkOption {
      default = "";
      example = "foobar";
      description = ''
        The password of the database user.  Warning: this is stored in
        cleartext in the Nix store!
      '';
    };

    emergencyContact = mkOption {
      default = serverInfo.serverConfig.adminAddr;
      example = "admin@example.com";
      description = ''
        Emergency contact e-mail address.  Defaults to the Apache
        admin address.
      '';
    };

    passwordSender = mkOption {
      default = serverInfo.serverConfig.adminAddr;
      example = "password@example.com";
      description = ''
        E-mail address from which password confirmations originate.
        Defaults to the Apache admin address.
      '';
    };

    siteName = mkOption {
      default = "MediaWiki";
      example = "Foobar Wiki";
      description = "Name of the wiki";
    };

    logo = mkOption {
      default = "";
      example = "/images/logo.png";
      description = "The URL of the site's logo (which should be a 135x135px image).";
    };

    urlPrefix = mkOption {
      default = "/w";
      description = ''
        The URL prefix under which the Mediawiki service appears.
      '';
    };

    articleUrlPrefix = mkOption {
      default = "/wiki";
      example = "";
      description = ''
        The URL prefix under which article pages appear,
        e.g. http://server/wiki/Page.  Leave empty to use the main URL
        prefix, e.g. http://server/w/index.php?title=Page.
      '';
    };

    enableUploads = mkOption {
      default = false;
      description = "Whether to enable file uploads.";
    };

    uploadDir = mkOption {
      default = throw "You must specify `uploadDir'.";
      example = "/data/mediawiki-upload";
      description = "The directory that stores uploaded files.";
    };

    defaultSkin = mkOption {
      default = "";
      example = "nostalgia";
      description = "Set this value to change the default skin used by MediaWiki.";
    };

    skins = mkOption {
      default = [];
      type = types.listOf types.path;
      description =
        ''
          List of paths whose content is copied to the ‘skins’
          subdirectory of the MediaWiki installation.
        '';
    };

    extraConfig = mkOption {
      default = "";
      example =
        ''
          $wgEnableEmail = false;
        '';
      description = ''
        Any additional text to be appended to MediaWiki's
        configuration file.  This is a PHP script.  For configuration
        settings, see <link xlink:href='http://www.mediawiki.org/wiki/Manual:Configuration_settings'/>.
      '';
    };

  };

  # extraPath = [ mediawikiScripts ];

  # !!! Need to specify that Apache has a dependency on PostgreSQL!

}
