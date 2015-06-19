# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/axel/axel-1.1.ebuild,v 1.8 2011/05/01 14:49:25 jlec Exp $

inherit toolchain-funcs

DOWNLOAD_ID=2287

DESCRIPTION="Light Unix download accelerator"
HOMEPAGE="http://axel.alioth.debian.org/"
SRC_URI="http://alioth.debian.org/frs/download.php/${DOWNLOAD_ID}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 hppa ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="debug nls"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Set LDFLAGS and fix expr
	sed -i -e 's/expr/& --/' -e "s/^LFLAGS=$/&${LDFLAGS}/" configure
}

src_compile() {
	local myconf

	use debug && myconf="--debug=1"
	use nls && myconf="--i18n=1"
	econf \
		--strip=0 \
		--etcdir=/etc \
		${myconf} \
		|| die

	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc API CHANGES CREDITS README axelrc.example
}

pkg_postinst() {
	einfo 'To use axel with portage, try these settings in your make.conf'
	einfo
	einfo ' FETCHCOMMAND="/usr/bin/axel -a -o \${DISTDIR}/\${FILE} \${URI}"'
	einfo ' RESUMECOMMAND="${FETCHCOMMAND}"'
}
