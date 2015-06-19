# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/bmf/bmf-0.9.4-r2.ebuild,v 1.5 2013/07/08 11:13:29 zlogene Exp $

EAPI=4
inherit toolchain-funcs eutils

IUSE="mysql berkdb"

DESCRIPTION="A fast and small Bayesian spam filter"
HOMEPAGE="http://bmf.sourceforge.net/"
SRC_URI="mirror://sourceforge/bmf/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="mysql? ( virtual/mysql )
	berkdb? ( >=sys-libs/db-3.2.9 )"
RDEPEND="${DEPEND}"

src_prepare() {
	# respect CFLAGS
	sed -i -e '/D_LINUX/s/CFLAGS="$CCDBG/CFLAGS+=" $CCDBG/' \
		"${S}/configure" || die

	# include mysql headers
	sed -i -e '/HAVE_MYSQL/s/HAVE_MYSQL/HAVE_MYSQL `mysql_config --include`/' \
		"${S}/configure" || die

	epatch "${FILESDIR}/${P}_QA.patch"
}

src_configure() {
	# this is not an autotools script
	./configure \
		$(use_with mysql) \
		$(use_with berkdb libdb) || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README AUTHORS ChangeLog
}

pkg_postinst() {
	elog
	elog "Important: Remember to train bmf before you start using it."
	elog "See the README file for further instructions on training and using bmf"
	elog "with procmail."
	elog
}
