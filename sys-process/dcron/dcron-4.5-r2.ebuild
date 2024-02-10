# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cron toolchain-funcs systemd

DESCRIPTION="A cute little cron from Matt Dillon"
HOMEPAGE="
	http://www.jimpryor.net/linux/dcron.html
	http://apollo.backplane.com/FreeSrc/"
SRC_URI="http://www.jimpryor.net/linux/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

PATCHES=(
	"${FILESDIR}"/${PN}-4.5-ldflags.patch
	"${FILESDIR}"/${PN}-4.5-pidfile.patch
)

src_configure() {
	tc-export CC

	cat > config <<-EOF || die
		PREFIX = /usr
		CRONTAB_GROUP = cron
	EOF
}

src_install() {
	default
	dodoc extra/run-cron extra/root.crontab "${FILESDIR}"/crontab

	docrondir
	docron crond -m0700 -o root -g wheel
	docrontab

	insinto /etc
	doins "${FILESDIR}"/crontab

	insinto /etc/cron.d
	doins extra/prune-cronstamps

	insinto /etc/logrotate.d
	newins extra/crond.logrotate dcron

	keepdir /var/spool/cron/cronstamps

	newinitd "${FILESDIR}"/dcron.init dcron
	newconfd "${FILESDIR}"/dcron.confd dcron
	systemd_dounit "${FILESDIR}"/dcron.service
}
