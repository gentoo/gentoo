# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="A simple, easily embeddable cross-platform C library"
HOMEPAGE="https://github.com/dcreager/libcork"
SRC_URI="https://github.com/dcreager/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="static-libs"

RDEPEND="dev-libs/check"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-git.patch"
	"${FILESDIR}/${P}-version.patch"
)

src_prepare() {
	if ! [ -e "${S}"/RELEASE-VERSION ] ; then
		echo ${PV} > "${S}"/RELEASE-VERSION || die
	fi
	sed -i -e "/DESTINATION/s/\${PROJECT_NAME}/\${PROJECT_NAME}-${PVR}/g" \
		docs/old/CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_STATIC=$(usex static-libs)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
