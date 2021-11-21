# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=XAOC
DIST_VERSION=0.049
inherit perl-module xdg-utils

DESCRIPTION="Dynamically create Perl language bindings"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc x86"

RDEPEND="
	>=dev-perl/glib-perl-1.320.0
	>=dev-libs/gobject-introspection-1.0
	>=dev-libs/libffi-3.0.0:0=
	>=dev-libs/glib-2.0.0
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-perl/ExtUtils-Depends-0.300.0
	>=dev-perl/ExtUtils-PkgConfig-1.0.0
	${RDEPEND}
"

pkg_setup() {
	xdg_environment_reset	# bug #599128
}
