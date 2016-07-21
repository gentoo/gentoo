# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

DOWNLOAD_ID=3016

DESCRIPTION="Light Unix download accelerator"
HOMEPAGE="http://axel.alioth.debian.org/"
SRC_URI="http://alioth.debian.org/frs/download.php/${DOWNLOAD_ID}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc64-solaris"
IUSE="debug nls"

DEPEND="nls? ( sys-devel/gettext )"
RDEPEND="nls? ( virtual/libintl )"

DOCS=( API CHANGES CREDITS README axelrc.example )

src_prepare() {
	append-lfs-flags
	epatch \
		"${FILESDIR}"/${P}-buildsystem.patch \
		"${FILESDIR}"/${P}-bffr-overflow.patch \
		"${FILESDIR}"/${P}-max-redir.patch
	tc-export CC
}

src_configure() {
	local myconf=()

	use debug && myconf+=( --debug=1 )
	myconf+=( --i18n=$(usex nls 1 0) )
	econf \
		--strip=0 \
		${myconf[@]}
}

pkg_postinst() {
	einfo 'To use axel with portage, try these settings in your make.conf'
	einfo
	einfo ' FETCHCOMMAND='\''axel -a -o "\${DISTDIR}/\${FILE}.axel" "\${URI}" && mv "\${DISTDIR}/\${FILE}.axel" "\${DISTDIR}/\${FILE}"'\'
	einfo ' RESUMECOMMAND="${FETCHCOMMAND}"'
}
