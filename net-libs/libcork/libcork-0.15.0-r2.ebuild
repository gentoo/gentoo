# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

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
	sed -i -e "s/-Werror/-Wextra/" \
		-e "/docs\/old/d" \
		CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_STATIC=$(usex static-libs)
	)
	cmake_src_configure
}
