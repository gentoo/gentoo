# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic

GIT_COMMIT=fec3683b971d9c3ef73f284f176672c44b448662
DESCRIPTION="A tiny but valid init for containers"
HOMEPAGE="https://github.com/krallin/tini"
SRC_URI="https://github.com/krallin/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+args +static"

src_prepare() {
	cmake-utils_src_prepare
	# Do not strip binary
	sed -i -e 's/-Wl,-s")$/")/' \
		-e "s/git.*status --porcelain.*/true/" \
		-e "s/git.*log -n 1.*/true/" \
		-e "s/git.\${tini_VERSION_GIT}/git.${GIT_COMMIT}/" \
		CMakeLists.txt || die
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
