# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Ridiculously functional reminder program"
HOMEPAGE="https://dianne.skoll.ca/projects/remind/"
SRC_URI="https://dianne.skoll.ca/projects/remind/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="tk"

RDEPEND="
	tk? ( >=dev-lang/tk-8.5 dev-tcltk/tcllib )
"
DEPEND="${RDEPEND}
	dev-perl/Cairo
	dev-perl/JSON-MaybeXS
	dev-perl/Pango
	virtual/perl-Getopt-Long
"
DOCS="docs/* examples/defs.rem "

src_prepare() {
	default
	sed -i 's:@CC@ @LDFLAGS@:@CC@ @CFLAGS@ @LDFLAGS@:' "${S}"/src/Makefile.in || die
	sed -i 's:$(MAKE) -C src install:&-nostripped:' "${S}"/Makefile || die
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

	if ! use tk ; then
		rm \
			"${D}"/usr/bin/tkremind \
			"${D}"/usr/share/man/man1/tkremind* \
			|| die
	fi

	rm "${S}"/contrib/rem2ics-*/{Makefile,rem2ics.spec} || die
	insinto /usr/share/${PN}
	doins -r contrib/
	insinto /usr/share/vim/vimfiles/syntax
	doins examples/remind.vim
}
