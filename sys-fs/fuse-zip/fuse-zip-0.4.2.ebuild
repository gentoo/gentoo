# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="FUSE file system to navigate, extract, create and modify ZIP archives"
HOMEPAGE="https://bitbucket.org/agalanin/fuse-zip"
SRC_URI="https://bitbucket.org/agalanin/${PN}/downloads/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/libzip-0.11.2:=
	>=sys-fs/fuse-2.7:="
RDEPEND="${DEPEND}"

RESTRICT="test"

src_prepare() {
	# Fix strip than installing fuse-zip
	sed -i -e 's/install -m 755 -s/install -m 755/' Makefile || die "sed failed"
	#enable parallel build
	sed -i -e "s:make :\$\(MAKE\) :" Makefile || die "sed failed"
	# Fix prefix
	sed -i -e "s:^prefix=.*:prefix=/usr:" Makefile || die "sed failed"
}

src_compile() {
	emake CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS} ${LDFLAGS}"
}
