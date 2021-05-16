# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Cygwin Encryption/Decryption utility and library"
HOMEPAGE="https://sourceware.org/cygwin-apps/"
# Upstream provides the git repo only, so we do:
#  git clone git://cygwin.com/git/cygwin-apps/crypt.git
#  cd crypt
#  git archive -o cygwin-crypt-${PV}.tar --prefix=cygwin-crypt-${PV}/ crypt-${PV}-release
#  bzip2 cygwin-crypt-${PV}.tar
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~x64-cygwin"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

mymake() {
	emake \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		CFLAGS="${CFLAGS}" \
		prefix="${EPREFIX}/usr" \
		docdir="${EPREFIX}/share/doc/${P}" \
		"$@"
}

src_compile() {
	mymake
}

src_install() {
	mymake install DESTDIR="${D}"
}
