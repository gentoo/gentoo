# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SHLOMIF
DIST_VERSION=2.0210
DIST_EXAMPLES=("example/*")
inherit perl-module

DESCRIPTION="Perl binding for libxml2"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
IUSE="minimal"

# >= on XML-Sax needed to avoid "miscompilation" (essentially empty install), as newer XML-Sax
# has the ROOT check fixed. Didn't happen with XML-SAX-Expat, but best to be careful.
# bug #840053
RDEPEND="
	virtual/perl-Carp
	virtual/perl-Encode
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-IO
	virtual/perl-Scalar-List-Utils
	>=dev-perl/XML-NamespaceSupport-1.70.0
	>=dev-perl/XML-SAX-1.20.0-r1
	dev-perl/XML-SAX-Base
	>=dev-libs/libxml2-2.6.21:2=
	virtual/perl-parent
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	dev-perl/Alien-Build
	>=dev-perl/Alien-Libxml2-0.140.0
	test? (
		!minimal? (
			dev-perl/Test-LeakTrace
		)
	)
"
DEPEND=">=dev-libs/libxml2-2.6.21:2="

PERL_RM_FILES=(
	"t/cpan-changes.t" "t/pod-files-presence.t" "t/pod.t"
	"t/release-kwalitee.t" "t/style-trailing-space.t"
	"t/11memory.t"
)

src_compile() {
	export SKIP_SAX_INSTALL=1
	perl-module_src_compile
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

	if [[ -z "${ROOT}" ]] ; then
		einfo "Update Parser: $1 $2"
		perl -MXML::SAX -e "XML::SAX->${action}_parser(q(${parser_module}))->save_parsers()" \
			|| ewarn "Update Parser: $1 $2 failed"
	else
		elog "To $1 $2 run:"
		elog "perl -MXML::SAX -e 'XML::SAX->${action}_parser(q(${parser_module}))->save_parsers()'"
	fi
}
