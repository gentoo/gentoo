# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Suite of programs to modify openttd/Transport Tycoon Deluxe's GRF files"
HOMEPAGE="https://github.com/OpenTTD/grfcodec"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/OpenTTD/grfcodec"
	inherit git-r3
else
	SRC_URI="https://github.com/OpenTTD/grfcodec/releases/download/${PV}/${P}-source.tar.xz"

	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="media-libs/libpng:="
DEPEND="
	${RDEPEND}
	dev-libs/boost
"

PATCHES=(
	"${FILESDIR}"/${PN}-6.1.0-cmake-install.patch

	# Bug #894648
	"${FILESDIR}"/${PN}-6.0.6_p20230811-no-fortify-source.patch
)

src_install() {
	cmake_src_install

	rm "${ED}"/usr/share/doc/${PF}/COPYING || die
}
