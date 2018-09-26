# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=GRANTM
DIST_VERSION=1.00
inherit perl-module eutils

DESCRIPTION="Perl module for using and building Perl SAX2 XML parsers, filters, and drivers"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	>=dev-perl/XML-SAX-Base-1.50.0
	>=dev-perl/XML-NamespaceSupport-1.40.0
	>=dev-libs/libxml2-2.4.1
	virtual/perl-File-Temp
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
PATCHES=("${FILESDIR}/${PN}-1.00-noautoini.patch")

pkg_postinst() {
	pkg_update_parser add XML::SAX::PurePerl
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
