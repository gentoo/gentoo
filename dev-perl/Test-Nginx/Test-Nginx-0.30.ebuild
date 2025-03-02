# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AGENT
inherit perl-module

DESCRIPTION="Data-driven test scaffold for NGINX and OpenResty"

LICENSE="BSD"

SLOT="0"

# The following packages in the dev-perl category provide the required Perl
# modules that Test-Nginx depends on:
#     (1) libwww-perl provides LWP::UserAgent,
#     (2) HTTP-Message provides HTTP::Response,
#     (3) URI provides URI::Escape.
RDEPEND="
	dev-perl/HTTP-Message
	dev-perl/IPC-Run
	dev-perl/List-MoreUtils
	dev-perl/Test-Base
	dev-perl/Test-LongString
	dev-perl/Text-Diff
	dev-perl/libwww-perl
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-File-Temp
	virtual/perl-Time-HiRes
"

PATCHES=(
	"${FILESDIR}/${PN}-0.30-preset-temp_path-directives.patch"
	"${FILESDIR}/${PN}-0.30-set-default-error-log.patch"
)
