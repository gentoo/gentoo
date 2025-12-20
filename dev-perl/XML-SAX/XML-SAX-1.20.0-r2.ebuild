# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GRANTM
DIST_VERSION=1.02
inherit perl-module

DESCRIPTION="Perl module for using and building Perl SAX2 XML parsers, filters, and drivers"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-perl/XML-SAX-Base-1.50.0
	>=dev-perl/XML-NamespaceSupport-0.30.0
	>=dev-libs/libxml2-2.4.1:=
	virtual/perl-File-Temp
"
BDEPEND="${RDEPEND}
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

	if [[ -z "${ROOT}" ]] ; then
		einfo "Update Parser: $1 $2"
		perl -MXML::SAX -e "XML::SAX->${action}_parser(q(${parser_module}))->save_parsers()" \
			|| ewarn "Update Parser: $1 $2 failed"
	else
		elog "To $1 $2 run:"
		elog "perl -MXML::SAX -e 'XML::SAX->${action}_parser(q(${parser_module}))->save_parsers()'"
	fi
}
