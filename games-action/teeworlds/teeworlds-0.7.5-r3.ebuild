# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit cmake desktop flag-o-matic python-any-r1

DESCRIPTION="Online multi-player platform 2D shooter"
HOMEPAGE="https://www.teeworlds.com/"
SRC_URI="
	https://github.com/teeworlds/teeworlds/releases/download/${PV}/teeworlds-${PV}-src.tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png
"
S=${WORKDIR}/${P}-src

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="dedicated test"
RESTRICT="!test? ( test )"

RDEPEND="
	!dedicated? (
		media-libs/freetype
		media-libs/libglvnd[X]
		media-libs/libsdl2[sound,opengl,video]
		media-libs/pnglite
		media-sound/wavpack
	)
	dev-libs/openssl:=
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	test? ( dev-cpp/gtest )
"

src_configure() {
	append-flags -fno-strict-aliasing #858524

	local mycmakeargs=(
		-DCLIENT=$(usex !dedicated)
		-DCMAKE_DISABLE_FIND_PACKAGE_X11=yes # unused
	)

	cmake_src_configure
}

src_test() {
	eninja run_tests
}

src_install() {
	cmake_src_install

	doicon "${DISTDIR}"/${PN}.png
	domenu other/teeworlds.desktop

	newinitd "${FILESDIR}"/${PN}-init.d ${PN}

	insinto /etc/${PN}
	doins "${FILESDIR}"/teeworlds_srv.cfg
}
