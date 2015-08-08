# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="Provides a trash can by intercepting certain calls to glibc"
HOMEPAGE="http://pages.stern.nyu.edu/~marriaga/software/libtrash/"
SRC_URI="http://pages.stern.nyu.edu/~marriaga/software/libtrash/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack "${A}"

	# now let's unpack strash too in cash anyone is interested
	cd "${S}/cleanTrash" || die "cd failed"
	unpack ./strash-0.9.tar.gz
}

src_prepare() {
	epatch "${FILESDIR}/${P}-gentoo.patch"
	epatch "${FILESDIR}/${P}-ldflags.patch" # bug 334833
	sed -i -e "/^INSTLIBDIR/s:local/lib:$(get_libdir):" src/Makefile || die "sed on Makefile failed"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dodir /etc /usr/$(get_libdir)
	emake DESTDIR="${D}" install

	dosbin cleanTrash/ct2.pl
	exeinto /etc/cron.daily
	doexe "${FILESDIR}/cleanTrash.cron"

	dodoc CHANGE.LOG README libtrash.conf TODO config.txt

	docinto cleanTrash
	dodoc cleanTrash/README cleanTrash/cleanTrash

	# new strash installation stuff
	dosbin cleanTrash/strash-0.9/strash
	docinto strash
	dodoc cleanTrash/strash-0.9/README
	doman cleanTrash/strash-0.9/strash.8
}

pkg_postinst() {
	elog
	elog "To use this you have to put the trash library as one"
	elog "of the variables in LD_PRELOAD."
	elog "Example in bash:"
	elog "export LD_PRELOAD=/usr/$(get_libdir)/libtrash.so"
	elog
	elog "Also, see /etc/cron.daily/cleanTrash.cron if you'd like to turn on"
	elog "daily trash cleanup."
	elog
}
