# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cron toolchain-funcs systemd

DESCRIPTION="Dillon's lightweight and minimalist cron daemon"
HOMEPAGE="https://github.com/ptchinster/dcron"
SRC_URI="https://github.com/ptchinster/dcron/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_prepare() {
	default
	# fix typo: https://github.com/ptchinster/dcron/pull/2
	sed -i 's/CLFAGS/CFLAGS/g' Makefile || die

	# use system LDFLAGS: https://github.com/ptchinster/dcron/issues/3
	sed -i 's/^LDFLAGS =//g' Makefile || die
}

src_configure() {
	tc-export CC

	cat > config <<-EOF || die
		PREFIX = /usr
		CRONTAB_GROUP = cron
	EOF
}

src_test(){ : ; } # no tests

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
