# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=BJOERN
MODULE_VERSION=0.51
inherit perl-module

DESCRIPTION="SAX2 Driver for Expat"
LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="test"

RDEPEND=">=dev-perl/XML-SAX-0.15-r1
	>=dev-perl/XML-NamespaceSupport-1.09
	dev-perl/XML-Parser"
DEPEND="${RDEPEND}
	test? (
		virtual/perl-Test-Simple
	)"

SRC_TEST=do

src_test() {
	perl_rm_files t/98podsyn.t t/99podcov.t
	perl-module_src_test
}

src_compile() {
	export SKIP_SAX_INSTALL=1
	perl-module_src_compile
}

pkg_postinst() {
	pkg_update_parser add XML::SAX::Expat
}

pkg_postrm() {
	pkg_update_parser remove XML::SAX::Expat
}

pkg_update_parser() {
	# pkg_update_parser [add|remove] $parser_module
	local action=$1
	local parser_module=$2

	if [[ "$ROOT" = "/" ]] ; then
		einfo "Update Parser: $1 $2"
		perl -MXML::SAX -e "XML::SAX->${action}_parser(q(${parser_module}))->save_parsers()" \
			|| ewarn "Update Parser: $1 $2 failed"
	else
		elog "To $1 $2 run:"
		elog "perl -MXML::SAX -e 'XML::SAX->${action}_parser(q(${parser_module}))->save_parsers()'"
	fi
}
