# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Converts images from gif format to png format"
HOMEPAGE="http://catb.org/~esr/gif2png/"
SRC_URI="http://catb.org/~esr/${PN}/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 -ppc ~ppc64 -sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND=">=media-libs/libpng-1.2:0=
	sys-libs/zlib:="

DEPEND="${RDEPEND}"

BDEPEND="
	>=dev-lang/go-1.17.5"

#tests fail because of old python syntax
#RESTRICT until tests are modernized
RESTRICT=test

src_prepare() {
	default
	cd "${S}" || die
	go mod init gif2png || die "go module init failed"
	go get golang.org/x/crypto/ssh/terminal || die "failed to get terminal package"
	go get golang.org/x/sys/unix || die "failed to get unix package"
	tc-export CC
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install
}
