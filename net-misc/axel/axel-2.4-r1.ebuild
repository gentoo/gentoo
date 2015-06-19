# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/axel/axel-2.4-r1.ebuild,v 1.1 2011/05/01 14:49:25 jlec Exp $

EAPI="2"

inherit eutils flag-o-matic toolchain-funcs

DOWNLOAD_ID=3016

DESCRIPTION="Light Unix download accelerator"
HOMEPAGE="http://axel.alioth.debian.org/"
SRC_URI="http://alioth.debian.org/frs/download.php/${DOWNLOAD_ID}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc64-solaris"
IUSE="debug nls"

DEPEND="nls? ( sys-devel/gettext )"
RDEPEND="nls? ( virtual/libintl )"

src_prepare() {
	append-lfs-flags
	sed -i -e "s/^LFLAGS=$/&${LDFLAGS}/" configure || die "sed failed"
}

src_configure() {
	local myconf=""

	use debug && myconf+=" --debug=1"
	use nls && myconf+=" --i18n=$(use nls && echo 1 || echo 0)"
	econf \
		--strip=0 \
		${myconf}
}

src_compile() {
	emake CFLAGS="${CPPFLAGS} ${CFLAGS}" CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc API CHANGES CREDITS README axelrc.example || die "dodoc failed"
}

pkg_postinst() {
	einfo 'To use axel with portage, try these settings in your make.conf'
	einfo
	einfo ' FETCHCOMMAND='\''axel -a -o "\${DISTDIR}/\${FILE}.axel" "\${URI}" && mv "\${DISTDIR}/\${FILE}.axel" "\${DISTDIR}/\${FILE}"'\'
	einfo ' RESUMECOMMAND="${FETCHCOMMAND}"'
}
