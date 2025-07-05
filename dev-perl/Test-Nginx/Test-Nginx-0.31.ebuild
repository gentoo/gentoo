# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AGENT
inherit perl-module

MY_PN="test-nginx"
DESCRIPTION="Data-driven test scaffold for NGINX and OpenResty"
HOMEPAGE+=" https://github.com/openresty/test-nginx"
SRC_URI="https://github.com/openresty/test-nginx/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

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
	dev-perl/URI
	dev-perl/libwww-perl
"
