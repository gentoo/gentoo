# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit cron toolchain-funcs eutils systemd

DESCRIPTION="A cute little cron from Matt Dillon"
HOMEPAGE="http://www.jimpryor.net/linux/dcron.html http://apollo.backplane.com/FreeSrc/"
SRC_URI="http://www.jimpryor.net/linux/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
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
	emake install DESTDIR="${D}"
	dodoc CHANGELOG README "${FILESDIR}"/crontab

	docrondir
	docron crond -m0700 -o root -g wheel
	docrontab

	insinto /etc
	doins "${FILESDIR}"/crontab
	insinto /etc/cron.d
	doins extra/prune-cronstamps
	dodoc extra/run-cron extra/root.crontab

	newinitd "${FILESDIR}"/dcron.init dcron
	newconfd "${FILESDIR}"/dcron.confd dcron
	systemd_dounit "${FILESDIR}"/dcron.service

	insinto /etc/logrotate.d
	newins extra/crond.logrotate dcron
}
