# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BJOERN
DIST_VERSION=0.51
inherit perl-module

DESCRIPTION="SAX2 Driver for Expat"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

# >= on XML-Sax needed to avoid "miscompilation" (essentially empty install), as newer XML-Sax
# has the ROOT check fixed. Didn't happen with XML-SAX-Expat, but best to be careful.
# bug #840053
RDEPEND="
	>=dev-perl/XML-SAX-1.20.0-r1
	>=dev-perl/XML-NamespaceSupport-1.90.0
	dev-perl/XML-Parser
"
BDEPEND="${RDEPEND}
	test? (
		virtual/perl-Test-Simple
	)
"

src_compile() {
	export SKIP_SAX_INSTALL=1
	perl-module_src_compile
}

src_test() {
	perl_rm_files t/98podsyn.t t/99podcov.t
	perl-module_src_test
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

	if [[ -z "${ROOT}" ]] ; then
		einfo "Update Parser: $1 $2"
		perl -MXML::SAX -e "XML::SAX->${action}_parser(q(${parser_module}))->save_parsers()" \
			|| ewarn "Update Parser: $1 $2 failed"
	else
		elog "To $1 $2 run:"
		elog "perl -MXML::SAX -e 'XML::SAX->${action}_parser(q(${parser_module}))->save_parsers()'"
	fi
}
