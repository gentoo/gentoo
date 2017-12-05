# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=XAOC
DIST_VERSION=0.043
inherit perl-module xdg-utils

DESCRIPTION="Dynamically create Perl language bindings"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/glib-perl-1.320.0
	>=dev-libs/gobject-introspection-1.0
	>=dev-libs/libffi-3.0.0
	>=dev-libs/glib-2.0.0
"
DEPEND="
	>=dev-perl/ExtUtils-Depends-0.300.0
	>=dev-perl/ExtUtils-PkgConfig-1.0.0
	${RDEPEND}
"

pkg_setup() {
	xdg_environment_reset	# bug #599128
}
