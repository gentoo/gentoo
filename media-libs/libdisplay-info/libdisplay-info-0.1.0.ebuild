# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

inherit meson

DESCRIPTION="Simple framework for writing Vulkan layers"
HOMEPAGE="https://gitlab.freedesktop.org/emersion/libdisplay-info"
SRC_URI="https://gitlab.freedesktop.org/emersion/${PN}/-/releases/${PV}/downloads/${P}.tar.xz"
KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="sys-apps/hwdata"
DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	test? ( >=sys-apps/edid-decode-0_pre20230131 )
"
