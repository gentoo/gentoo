# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SHLOMIF
DIST_VERSION=2.0201
DIST_EXAMPLES=("example/*")
inherit perl-module

DESCRIPTION="Perl binding for libxml2"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86"
IUSE="test minimal"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Encode
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-IO
	virtual/perl-Scalar-List-Utils
	>=dev-perl/XML-SAX-0.120.0
	>=dev-libs/libxml2-2.6.21:2=
	dev-perl/XML-SAX-Base
	>=dev-perl/XML-NamespaceSupport-1.70.0
	virtual/perl-XSLoader
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	dev-perl/Alien-Libxml2
	test? (
		!minimal? (
			dev-perl/Test-LeakTrace
		)
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-2.12.800-disable-expanding.patch"
)

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

	if [[ "$ROOT" = "/" ]] ; then
		einfo "Update Parser: $1 $2"
		perl -MXML::SAX -e "XML::SAX->${action}_parser(q(${parser_module}))->save_parsers()" \
			|| ewarn "Update Parser: $1 $2 failed"
	else
		elog "To $1 $2 run:"
		elog "perl -MXML::SAX -e 'XML::SAX->${action}_parser(q(${parser_module}))->save_parsers()'"
	fi
}
