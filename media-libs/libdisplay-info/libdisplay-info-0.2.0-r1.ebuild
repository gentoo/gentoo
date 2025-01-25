# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit meson python-any-r1

DESCRIPTION="EDID and DisplayID library"
HOMEPAGE="https://gitlab.freedesktop.org/emersion/libdisplay-info"
SRC_URI="https://gitlab.freedesktop.org/emersion/${PN}/-/releases/${PV}/downloads/${P}.tar.xz"

LICENSE="MIT"
SLOT="0/2"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

BDEPEND="
	${PYTHON_DEPS}
	sys-apps/hwdata
	virtual/pkgconfig
"
