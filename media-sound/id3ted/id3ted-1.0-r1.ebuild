# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A Command-line ID3 Tag Editor"
HOMEPAGE="https://github.com/xyb3rt/id3ted"
SRC_URI="https://github.com/xyb3rt/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="
	media-libs/taglib:=
	sys-apps/file"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-outofbounds.patch"
	"${FILESDIR}/${P}-fix-build-taglib2.patch"
)

pkg_setup() {
	export PREFIX="/usr"
	tc-export CXX
}
