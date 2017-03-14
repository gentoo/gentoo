# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SHLOMIF
DIST_VERSION=2.0128
DIST_EXAMPLES=("example/*")
inherit perl-module

DESCRIPTION="Perl binding for libxml2"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="test minimal"

RDEPEND="
	>=dev-perl/XML-SAX-0.120.0
	>=dev-libs/libxml2-2.6.21
	dev-perl/XML-SAX-Base
	>=dev-perl/XML-NamespaceSupport-1.70.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? (
			dev-perl/Test-LeakTrace
		)
	)
"

PATCHES=(
	"${FILESDIR}/${P}-disable-expanding.patch"
)

src_compile() {
	export SKIP_SAX_INSTALL=1
	perl-module_src_compile
}

src_test() {
	perl_rm_files t/pod.t t/style-trailing-space.t t/cpan-changes.t
	perl-module_src_test
}

pkg_postinst() {
	pkg_update_parser add XML::LibXML::SAX::Parser
	pkg_update_parser add XML::LibXML::SAX
}

pkg_postrm() {
	pkg_update_parser remove XML::LibXML::SAX::Parser
	pkg_update_parser remove XML::LibXML::SAX
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
