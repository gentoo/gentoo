# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

inherit meson python-any-r1

COMMIT="506925a66bfa3607c8de2c37dbe65659ecd1b9fb"
DESCRIPTION="Simple framework for writing Vulkan layers"
HOMEPAGE="https://gitlab.freedesktop.org/emersion/libdisplay-info"
SRC_URI="https://gitlab.freedesktop.org/emersion/${PN}/-/archive/${COMMIT}/${PN}-${COMMIT}.tar.bz2 -> ${P}.tar.bz2"
KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="sys-apps/hwdata"
DEPEND="${RDEPEND}"

BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	test? ( >=sys-apps/edid-decode-0_pre20230131 )
"

S="${WORKDIR}/${PN}-${COMMIT}"
