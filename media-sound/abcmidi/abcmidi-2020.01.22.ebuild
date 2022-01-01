# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P="abcMIDI-${PV}"

DESCRIPTION="Programs for processing ABC music notation files"
HOMEPAGE="https://ifdo.ca/~seymour/runabc/top.html"
SRC_URI="https://ifdo.ca/~seymour/runabc/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"

BDEPEND="app-arch/unzip"

S=${WORKDIR}/${PN}

PATCHES=(
	"${FILESDIR}"/${PN}-2016.05.05-docs.patch
	"${FILESDIR}"/${PN}-2016.05.05-fno-common.patch
)

src_prepare() {
	default

	rm configure Makefile || die
	sed -i "s:-O2::" configure.ac || die

	eautoreconf
}

src_install() {
	default
	dodoc doc/{AUTHORS,CHANGES,abcguide.txt,abcmatch.txt,history.txt,readme.txt,yapshelp.txt}

	docinto examples
	dodoc samples/*.abc
	docompress -x /usr/share/doc/${PF}/examples
}
