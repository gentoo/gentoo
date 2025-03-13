# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit meson python-any-r1

DESCRIPTION="EDID and DisplayID library"
HOMEPAGE="https://gitlab.freedesktop.org/emersion/libdisplay-info"
SRC_URI="https://gitlab.freedesktop.org/emersion/${PN}/-/releases/${PV}/downloads/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	${PYTHON_DEPS}
	sys-apps/hwdata
	virtual/pkgconfig
	test? ( >=sys-apps/edid-decode-0_pre20230131 )
"
