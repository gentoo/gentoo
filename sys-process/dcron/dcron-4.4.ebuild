# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/dcron/dcron-4.4.ebuild,v 1.2 2012/05/24 05:48:48 vapier Exp $

EAPI="2"

inherit cron toolchain-funcs eutils

DESCRIPTION="A cute little cron from Matt Dillon"
HOMEPAGE="http://www.jimpryor.net/linux/dcron.html http://apollo.backplane.com/FreeSrc/"
SRC_URI="http://www.jimpryor.net/linux/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-ldflags.patch
	epatch "${FILESDIR}"/${P}-pidfile.patch
	epatch "${FILESDIR}"/${P}-prune.patch
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

	newinitd "${FILESDIR}"/dcron.init-4.4 dcron || die
	newconfd "${FILESDIR}"/dcron.confd-4.4 dcron

	insinto /etc/logrotate.d
	newins extra/crond.logrotate dcron
}
