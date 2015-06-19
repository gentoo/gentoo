# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/dcron/dcron-4.5.ebuild,v 1.9 2012/07/01 18:20:07 armin76 Exp $

EAPI="2"

inherit cron toolchain-funcs eutils

DESCRIPTION="A cute little cron from Matt Dillon"
HOMEPAGE="http://www.jimpryor.net/linux/dcron.html http://apollo.backplane.com/FreeSrc/"
SRC_URI="http://www.jimpryor.net/linux/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.5-pidfile.patch
	epatch "${FILESDIR}"/${PN}-4.5-ldflags.patch
	tc-export CC
	cat <<-EOF > config
		PREFIX = /usr
		CRONTAB_GROUP = cron
	EOF
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc CHANGELOG README "${FILESDIR}"/crontab

	docrondir
	docron crond -m0700 -o root -g wheel
	docrontab

	insinto /etc
	doins "${FILESDIR}"/crontab || die
	insinto /etc/cron.d
	doins extra/prune-cronstamps || die
	dodoc extra/run-cron extra/root.crontab

	newinitd "${FILESDIR}"/dcron.init-4.5 dcron || die
	newconfd "${FILESDIR}"/dcron.confd-4.4 dcron

	insinto /etc/logrotate.d
	newins extra/crond.logrotate dcron
}

pkg_postinst() {
	# upstream renamed their pid file
	local src="${ROOT}/var/run/cron.pid" dst="${ROOT}/var/run/crond.pid"
	if [ -e "${src}" -a ! -e "${dst}" ] ; then
		cp "${src}" "${dst}"
	fi
}
