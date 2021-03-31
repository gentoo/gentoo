# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Script for converting XML and DocBook documents to a variety of output formats"
HOMEPAGE="https://pagure.io/xmlto"
SRC_URI="https://releases.pagure.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="latex text"

RDEPEND="app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.2
	dev-libs/libxslt
	|| ( sys-apps/util-linux app-misc/getopt )
	text? ( || ( virtual/w3m www-client/elinks www-client/links www-client/lynx ) )
	latex? ( dev-texlive/texlive-formatsextra )"
# We only depend on flex when we patch the input lexer.
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog FAQ NEWS README THANKS )

PATCHES=(
	"${FILESDIR}"/${PN}-0.0.22-format_fo_passivetex_check.patch
)

src_prepare() {
	default

	# fix symbol clash on Solaris
	if [[ ${CHOST} == *-solaris* ]] ; then
		sed -i -e 's/\(attrib\|val\)/XMLTO\1/g' xmlif/xmlif.l || die
	fi
}

src_configure() {
	# We don't want the script to detect /bin/sh if it is bash.
	export ac_cv_path_BASH="${BASH}"
	has_version sys-apps/util-linux || export GETOPT=getopt-long

	econf
}
