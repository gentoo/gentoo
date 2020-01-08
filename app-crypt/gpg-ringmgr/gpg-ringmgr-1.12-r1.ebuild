# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GPG Keyring Manager to handle large GPG keyrings more easily"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${PN} -> ${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc sparc x86"
IUSE=""

DEPEND="dev-lang/perl
	>=app-crypt/gnupg-1.2.1"

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}"/${P} ${PN} || die
}

src_compile() {
	pod2man ${PN} > ${PN}.1 || die
	pod2html ${PN} > ${PN}.html || die
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc ${PN}.html
}
