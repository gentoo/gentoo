# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit systemd toolchain-funcs

DESCRIPTION="systemd units to create timers for cron directories and crontab"
HOMEPAGE="https://github.com/systemd-cron/systemd-cron/"
SRC_URI="https://github.com/systemd-cron/${PN}/archive/v${PV}.tar.gz -> systemd-cron-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"
IUSE="cron-boot etc-crontab-systemd minutely +runparts setgid yearly"
RESTRICT="test"

BDEPEND="virtual/pkgconfig"

RDEPEND=">=sys-apps/systemd-253
	dev-libs/openssl
	runparts? ( sys-apps/debianutils )
	!sys-process/cronie[anacron]
	!etc-crontab-systemd? ( !sys-process/dcron )
	sys-process/cronbase
	acct-user/_cron-failure
	acct-group/_cron-failure"

DEPEND="sys-process/cronbase"

pkg_pretend() {
	if use runparts && ! [ -x /usr/bin/run-parts ] ; then
			eerror "Please complete the migration to merged-usr."
			eerror "https://wiki.gentoo.org/wiki/Merge-usr"
			die "systemd-cron no longer supports split-usr"
	fi
}

src_prepare() {
	sed -i \
		-e 's/^crontab/crontab-systemd/' \
		-e 's/^CRONTAB/CRONTAB-SYSTEMD/' \
		-- "${S}/src/man/crontab."{1,5}".in" || die

	if use etc-crontab-systemd
	then	sed -i \
			-e "s!/etc/crontab!/etc/crontab-systemd!" \
			-- "${S}/src/man/crontab."{1,5}".in" \
			"${S}/src/bin/systemd-crontab-generator.cpp" \
			"${S}/test/test-generator" || die
	fi

	eapply_user
}

my_use_enable() {
	if use ${1}; then
		echo --enable-${2:-${1}}=yes
	else
		echo --enable-${2:-${1}}=no
	fi
}

src_configure() {
	tc-export PKG_CONFIG CXX CC

	./configure \
		--prefix="${EPREFIX}/usr" \
		--mandir="${EPREFIX}/usr/share/man" \
		--unitdir="$(systemd_get_systemunitdir)" \
		--generatordir="$(systemd_get_systemgeneratordir)" \
		$(my_use_enable cron-boot boot) \
		$(my_use_enable minutely) \
		$(my_use_enable runparts) \
		$(my_use_enable yearly) \
		$(my_use_enable yearly quarterly) \
		$(my_use_enable yearly semi_annually) || die

		export CRONTAB=crontab-systemd
}

src_install() {
	default
	rm -f "${ED}"/usr/lib/sysusers.d/systemd-cron.conf
}

pkg_postinst() {
	elog "This package now supports USE=runparts which is enabled by default."
	elog "This enables the traditional run-parts behavior."
	elog "If you disable this flag you will get the new behavior of having"
	elog "multiple jobs for each cron.* entry run in parallel with"
	elog "separate services/logs/etc."
}
