# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic

DESCRIPTION="A tiny but valid init for containers"
HOMEPAGE="https://github.com/krallin/tini"
SRC_URI="https://github.com/krallin/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
IUSE="+args static"

src_prepare() {
	default
	# Do not strip binary
	sed -i -e 's/-Wl,-s")$/")/' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=()
	use args || mycmakeargs+=(-DMINIMAL=ON)

	cmake-utils_src_configure
}

src_compile() {
	append-cflags -DPR_SET_CHILD_SUBREAPER=36 -DPR_GET_CHILD_SUBREAPER=37
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	if use static; then
		mv "${ED%/}"/usr/bin/{${PN}-static,${PN}} || die
	else
		rm "${ED%/}"/usr/bin/${PN}-static || die
	fi
}
