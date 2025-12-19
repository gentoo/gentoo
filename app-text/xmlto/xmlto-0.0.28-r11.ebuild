# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Script for converting XML and DocBook documents to a variety of output formats"
HOMEPAGE="https://pagure.io/xmlto"
SRC_URI="https://releases.pagure.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="latex text"

RDEPEND="
	app-shells/bash:0
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.2
	dev-libs/libxslt
	|| ( sys-apps/util-linux app-misc/getopt )
	text? ( || ( virtual/w3m www-client/elinks www-client/links www-client/lynx ) )
	latex? ( dev-texlive/texlive-formatsextra )
"
DEPEND="${RDEPEND}"
# We only depend on lex when we patch the input lexer.
# We touch it in fix-warnings.patch.
BDEPEND="app-alternatives/lex"

DOCS=( AUTHORS ChangeLog FAQ NEWS README THANKS )

PATCHES=(
	"${FILESDIR}"/${PN}-0.0.22-format_fo_passivetex_check.patch
	"${FILESDIR}"/${PN}-0.0.28-allow-links.patch
	"${FILESDIR}"/${P}-dont-hardcode-paths.patch
	"${FILESDIR}"/${P}-fix-warnings.patch
)

src_prepare() {
	default

	# fix symbol clash on Solaris
	if [[ ${CHOST} == *-solaris* ]] ; then
		sed -i -e 's/\(attrib\|val\)/XMLTO\1/g' xmlif/xmlif.l || die
	fi

	eautoreconf
}

src_configure() {
	has_version sys-apps/util-linux || export GETOPT=getopt-long

	local args=(
		# Ensure we always get a #!/bin/bash shebang in xmlto, bug 912286
		BASH="${EPREFIX}/bin/bash"
	)

	econf "${args[@]}"
}
