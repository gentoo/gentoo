# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=$(ver_rs 2 -)
PYTHON_COMPAT=( python3_{9..10} )

inherit cmake python-single-r1

DESCRIPTION="Python bindings for libnest2d"
HOMEPAGE="https://github.com/Ultimaker/pynest2d"
SRC_URI="https://github.com/Ultimaker/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-libs/libnest2d
	$(python_gen_cond_dep '<dev-python/sip-5[${PYTHON_USEDEP}]')
	"

DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.12.1-required-flags-from-Libnest2D-target.patch
)

src_configure() {
	local mycmakeargs=(
		-DPython3_EXECUTABLE="${PYTHON}"
	)

	cmake_src_configure
}
