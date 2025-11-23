# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby31 ruby32 ruby33"
inherit edo ruby-single

DESCRIPTION="Reformat XML documents to your custom style"
SRC_URI="http://www.kitebird.com/software/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.kitebird.com/software/xmlformat/"

LICENSE="xmlformat"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc ruby"

DEPEND="
	dev-lang/perl
	ruby? ( ${RUBY_DEPS} )
"
RDEPEND="${DEPEND}"

src_test() {
	# Perl is always installed, so we may as well always test both.
	if use ruby; then
		nonfatal edo ./runtest all || die "runtest for ruby failed"
	fi

	nonfatal edo ./runtest -p all || die "runtest for perl failed"
}

src_install() {
	dobin xmlformat.pl

	if use ruby; then
		dobin xmlformat.rb
		dosym xmlformat.rb /usr/bin/xmlformat
	else
		dosym xmlformat.pl /usr/bin/xmlformat
	fi

	dodoc BUGS ChangeLog README TODO

	if use doc; then
		# APIs
		dodoc -r docs/*
	fi
}
