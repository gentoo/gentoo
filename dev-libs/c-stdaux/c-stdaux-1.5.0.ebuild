# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Auxiliary macros and functions for the C standard library"
HOMEPAGE="
	https://c-util.github.io/c-stdaux/
	https://github.com/c-util/c-stdaux/
"
SRC_URI="
	https://github.com/c-util/c-stdaux/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="|| ( Apache-2.0 LGPL-2.1+ )"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	virtual/pkgconfig
"
