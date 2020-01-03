# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="FUSE file system to navigate, extract, create and modify ZIP archives"
HOMEPAGE="https://bitbucket.org/agalanin/fuse-zip"
SRC_URI="https://bitbucket.org/agalanin/${PN}/downloads/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-libs/libzip:=
	sys-fs/fuse:0
"
RDEPEND="${DEPEND}"

RESTRICT="test"

DOCS=( changelog README.md )

PATCHES=( "${FILESDIR}/${PN}-0.4.5-makefile.patch" )

src_compile() {
	emake CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS} ${LDFLAGS}"
}

src_install() {
	default
	doman fuse-zip.1
}
