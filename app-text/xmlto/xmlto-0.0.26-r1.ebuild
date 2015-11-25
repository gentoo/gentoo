# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="script for converting XML and DocBook documents to a variety of output formats"
HOMEPAGE="https://fedorahosted.org/xmlto/"
SRC_URI="https://fedorahosted.org/releases/${PN:0:1}/${PN:1:1}/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="latex"

RDEPEND=">=app-text/docbook-xsl-stylesheets-1.62.0-r1
	app-text/docbook-xml-dtd:4.2
	app-shells/bash:0
	dev-libs/libxslt
	sys-apps/sed
	|| ( >=sys-apps/coreutils-6.10-r1 sys-freebsd/freebsd-ubin )
	|| ( sys-apps/util-linux app-misc/getopt )
	|| ( sys-apps/which sys-freebsd/freebsd-ubin )
	|| ( virtual/w3m www-client/lynx www-client/links )
	latex? ( >=app-text/passivetex-1.25 >=dev-tex/xmltex-1.9-r2 )"
# We only depend on flex when we patch the imput lexer.
DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog FAQ NEWS README THANKS"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.0.22-format_fo_passivetex_check.patch
}

src_configure() {
	# We don't want the script to detect /bin/sh if it is bash.
	export ac_cv_path_BASH=/bin/bash
	has_version sys-apps/util-linux || export GETOPT=getopt-long
	econf
}
