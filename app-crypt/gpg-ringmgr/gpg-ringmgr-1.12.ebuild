# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="GPG Keyring Manager to handle large GPG keyrings more easily"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc sparc x86"
IUSE=""

DEPEND="dev-lang/perl
	>=app-crypt/gnupg-1.2.1"

src_unpack() {
	mkdir ${P}
	cp "${DISTDIR}"/${PN} "${S}" || die
}

src_compile() {
	pod2man "${S}"/${PN} >"${S}/"${PN}.1
	pod2html "${S}"/${PN} >"${S}"/${PN}.html
}

src_install() {
	dobin ${PN} || die
	doman ${PN}.1
	dohtml ${PN}.html
}
