# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( pypy3 python3_{8..10} )
inherit python-single-r1 systemd

DESCRIPTION="systemd units to create timers for cron directories and crontab"
HOMEPAGE="https://github.com/systemd-cron/systemd-cron/"
MY_PV="1.15.18"
SRC_URI="https://github.com/systemd-cron/${PN}/archive/v${MY_PV}.tar.gz -> systemd-cron-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 ~riscv sparc x86"
IUSE="cron-boot etc-crontab-systemd minutely +runparts setgid test yearly"
RESTRICT="!test? ( test )"

RDEPEND=">=sys-apps/systemd-217
	sys-apps/debianutils
	!sys-process/cronie[anacron]
	!etc-crontab-systemd? ( !sys-process/dcron )
	${PYTHON_DEPS}
	sys-process/cronbase"

DEPEND="sys-process/cronbase
	test? ( sys-apps/man-db dev-python/pyflakes )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	python_fix_shebang --force "${S}/src/bin"

	sed -i \
		-e 's/^crontab/crontab-systemd/' \
		-e 's/^CRONTAB/CRONTAB-SYSTEMD/' \
		-- "${S}/src/man/crontab."{1,5}".in" || die

	sed -i \
		-e 's!/crontab$!/crontab-systemd!' \
		-e 's!/crontab\(\.[15]\)$!/crontab-systemd\1!' \
		-e 's/pyflakes3/pyflakes/' \
		-- "${S}/Makefile.in" || die

	if use etc-crontab-systemd
	then	sed -i \
			-e "s!/etc/crontab!/etc/crontab-systemd!" \
			-- "${S}/src/man/crontab."{1,5}".in" \
			"${S}/src/bin/systemd-crontab-generator.py" || die
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
	./configure \
		--prefix="${EPREFIX}/usr" \
		--confdir="${EPREFIX}/etc" \
		--runparts="${EPREFIX}/bin/run-parts" \
		--mandir="${EPREFIX}/usr/share/man" \
		--unitdir="$(systemd_get_systemunitdir)" \
		--generatordir="$(systemd_get_systemgeneratordir)" \
		$(my_use_enable cron-boot boot) \
		$(my_use_enable minutely) \
		$(my_use_enable runparts) \
		$(my_use_enable yearly) \
		$(my_use_enable yearly quarterly) \
		$(my_use_enable yearly semi_annually) \
		$(my_use_enable setgid) \
		--enable-persistent=yes
}

pkg_postinst() {
	elog "This package now supports USE=runparts which is enabled by default."
	elog "This enables the traditional run-parts behavior."
	elog "If you disable this flag you will get the new behavior of having"
	elog "multiple jobs for each cron.* entry run in parallel with"
	elog "separate services/logs/etc."
}
