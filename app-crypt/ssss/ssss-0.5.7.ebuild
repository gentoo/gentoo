# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Shamir's Secret Sharing Scheme"
HOMEPAGE="https://github.com/MrJoy/ssss"
SRC_URI="https://github.com/MrJoy/${PN}/archive/releases/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-releases-v${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-libs/gmp:0="
DEPEND="${RDEPEND}"
BDEPEND="app-doc/xmltoman"

HTML_DOCS=( "doc.html" "ssss.1.html" )

src_prepare() {
	default

	tc-export CC

	# Respect users [CL]FLAGS and don't strip, as portage does this part
	sed -e 's/-O2/$(CFLAGS) -lgmp $(LDFLAGS)/g' -e '/strip/d' -i Makefile || die
}

src_install() {
	dobin ssss-split
	dosym ssss-split /usr/bin/ssss-combine

	doman ssss.1

	einstalldocs
}
