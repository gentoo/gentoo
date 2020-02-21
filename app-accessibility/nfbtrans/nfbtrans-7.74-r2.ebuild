# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="braille translator from the National Federation of the Blind"
HOMEPAGE="http://www.nfb.org/nfbtrans"
SRC_URI="http://www.nfb.org/Images/nfb/Products_Technology/nfbtr774.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=" >=app-arch/unzip-5.50-r2"
RDEPEND=""

S=${WORKDIR}

PATCHES=(
"${FILESDIR}"/${P}-gentoo-fix.patch
"${FILESDIR}"/${P}-getline-fix.patch
"${FILESDIR}"/${P}-respect-ldflags.patch
)

src_prepare() {
	mv MAKEFILE Makefile || die
	mv SPANISH.ZIP spanish.zip || die
	emake lowercase
	default
}

src_compile() {
	emake CC=$(tc-getCC) \
		LIBS= \
		CFLAGS="${CFLAGS} -DLINUX" LDFLAGS="${LDFLAGS}" all
}

src_install() {
	dobin nfbtrans
	dodoc *fmt readme.txt makedoc
	insinto /etc/nfbtrans
	doins *cnf *tab *dic spell.dat *zip
}
