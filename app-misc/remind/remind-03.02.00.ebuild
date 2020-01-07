# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Ridiculously functional reminder program"
HOMEPAGE="https://dianne.skoll.ca/projects/remind/"
SRC_URI="https://dianne.skoll.ca/projects/remind/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="tk"

RDEPEND="
	tk? ( dev-lang/tk dev-tcltk/tcllib )
"
DOCS="docs/WHATSNEW examples/defs.rem www/README.*"

src_prepare() {
	default
	sed -i 's:$(MAKE) install:&-nostripped:' "${S}"/Makefile || die
}

src_test() {
	if [[ ${EUID} -eq 0 ]] ; then
		ewarn "Testing fails if run as root. Skipping tests"
	else
		emake test
	fi
}

src_install() {
	default
	dobin www/rem2html

	if ! use tk ; then
		rm \
			"${D}"/usr/bin/cm2rem* \
			"${D}"/usr/bin/tkremind \
			"${D}"/usr/share/man/man1/cm2rem* \
			"${D}"/usr/share/man/man1/tkremind* \
			|| die
	fi

	rm "${S}"/contrib/rem2ics-*/{Makefile,rem2ics.spec} || die
	insinto /usr/share/${PN}
	doins -r contrib/
}
