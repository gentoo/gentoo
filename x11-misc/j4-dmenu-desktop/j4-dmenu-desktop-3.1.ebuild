# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PV="r${PV}"

DESCRIPTION="A fast desktop replacement for i3-dmenu-desktop"
HOMEPAGE="https://github.com/enkore/j4-dmenu-desktop"
SRC_URI="https://github.com/enkore/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+dmenu test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-cpp/catch:0 )"
DEPEND="
	dev-libs/libfmt:=
	dev-libs/spdlog:=
"
RDEPEND="
	${DEPEND}
	dmenu? ( x11-misc/dmenu )
"

src_prepare() {
	cmake_src_prepare

	# Respect users CFLAGS
	sed -i -e "s/-pedantic -O2//" CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DNO_DOWNLOAD="ON"
		-DWITH_GIT_CATCH="no"
		-DWITH_TESTS="$(usex test)"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	doman j4-dmenu-desktop.1
}

pkg_postinst() {
	if ! use dmenu; then
		elog "As you have disabled the 'dmenu' use flag,"
		elog "x11-misc/dmenu won't be installed by default."
		elog ""
		elog "Since x11-misc/j4-dmenu-desktop uses x11-misc/dmenu as default,"
		elog "you must configure your own replacement with --dmenu=<command>,"
		elog "as otherwise it won't work."
	fi
}
