# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby22 ruby23 ruby24 ruby25"

inherit ruby-single

DESCRIPTION="Reformat XML documents to your custom style"
SRC_URI="http://www.kitebird.com/software/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.kitebird.com/software/xmlformat/"

SLOT="0"
LICENSE="xmlformat"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND="ruby? ( ${RUBY_DEPS} )
	!ruby? ( dev-lang/perl )"
RDEPEND=${DEPEND}
IUSE="ruby doc"

src_install() {
	dobin xmlformat.pl

	if use ruby
	then
		dobin xmlformat.rb
		dosym xmlformat.rb /usr/bin/xmlformat
	else
		dosym xmlformat.pl /usr/bin/xmlformat
	fi

	dodoc BUGS ChangeLog README TODO

	if use doc
	then
		# APIs
		insinto /usr/share/doc/${PF}
		doins -r docs/*
	fi
}

src_test() {
	if use ruby
	then
		./runtest all || die "runtest for ruby failed."
	else
		./runtest -p all || die "runtest for perl failed."
	fi
}
