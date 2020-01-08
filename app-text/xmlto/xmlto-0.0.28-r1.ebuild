# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="script for converting XML and DocBook documents to a variety of output formats"
HOMEPAGE="https://pagure.io/xmlto"
SRC_URI="https://releases.pagure.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="latex text"

RDEPEND=">=app-text/docbook-xsl-stylesheets-1.62.0-r1
	app-text/docbook-xml-dtd:4.2
	app-shells/bash:0
	dev-libs/libxslt
	sys-apps/sed
	|| ( >=sys-apps/coreutils-6.10-r1 sys-freebsd/freebsd-ubin )
	|| ( sys-apps/util-linux app-misc/getopt )
	|| ( sys-apps/which sys-freebsd/freebsd-ubin )
	text? ( || ( virtual/w3m www-client/lynx www-client/elinks ) )
	latex? ( >=app-text/passivetex-1.25 >=dev-tex/xmltex-1.9-r2 )"
# We only depend on flex when we patch the imput lexer.
DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog FAQ NEWS README THANKS"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.0.22-format_fo_passivetex_check.patch

	# fix symbol clash on Solaris
	if [[ ${CHOST} == *-solaris* ]] ; then
		sed -i -e 's/\(attrib\|val\)/XMLTO\1/g' xmlif/xmlif.l || die
	fi
}

src_configure() {
	# We don't want the script to detect /bin/sh if it is bash.
	export ac_cv_path_BASH=${BASH}
	has_version sys-apps/util-linux || export GETOPT=getopt-long
	econf
}
