# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Braille translator from the National Federation of the Blind"
HOMEPAGE="http://www.nfb.org/nfbtrans"
SRC_URI="http://www.nfb.org/Images/nfb/Products_Technology/nfbtr774.zip"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc x86"

BDEPEND=" >=app-arch/unzip-5.50-r2"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo-fix.patch
	"${FILESDIR}"/${P}-getline-fix.patch
	"${FILESDIR}"/${P}-respect-ldflags.patch
)

src_prepare() {
	mv MAKEFILE Makefile || die
	mv SPANISH.ZIP spanish.zip || die

	default

	emake lowercase
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LIBS= \
		CFLAGS="${CFLAGS} -DLINUX" \
		LDFLAGS="${LDFLAGS}" \
		all
}

src_install() {
	dobin nfbtrans
	dodoc *fmt readme.txt makedoc
	insinto /etc/nfbtrans
	doins *cnf *tab *dic spell.dat *zip
}
