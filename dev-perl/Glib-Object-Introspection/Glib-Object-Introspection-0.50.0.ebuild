# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=XAOC
DIST_VERSION=0.050
inherit perl-module xdg-utils

DESCRIPTION="Dynamically create Perl language bindings"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ppc64 ~riscv x86"

RDEPEND="
	>=dev-perl/glib-perl-1.320.0
	>=dev-libs/gobject-introspection-1.0
	>=dev-libs/libffi-3.0.0:=
	>=dev-libs/glib-2.0.0
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/ExtUtils-Depends-0.300.0
	>=dev-perl/ExtUtils-PkgConfig-1.0.0
"

pkg_setup() {
	# bug #599128
	xdg_environment_reset
}
