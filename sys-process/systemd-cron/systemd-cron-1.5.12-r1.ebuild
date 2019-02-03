# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( pypy3 python3_{4,5,6} )
inherit eutils python-single-r1 systemd

DESCRIPTION="systemd units to create timers for cron directories and crontab"
HOMEPAGE="https://github.com/systemd-cron/systemd-cron/"
SRC_URI="https://github.com/systemd-cron/${PN}/archive/v${PV}.tar.gz -> systemd-cron-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cron-boot etc-crontab-systemd minutely setgid test yearly"

RDEPEND=">=sys-apps/systemd-217
	     sys-apps/debianutils
	     !etc-crontab-systemd? ( !sys-process/dcron )
	     ${PYTHON_DEPS}
		 sys-process/cronbase"

DEPEND="sys-process/cronbase
	test? ( sys-apps/man-db dev-python/pyflakes )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	epatch "${FILESDIR}/1.5.12-generatordir.patch"

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

	epatch_user
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
		--unitdir="$(systemd_get_unitdir)" \
		--generatordir="$(systemd_get_systemgeneratordir)" \
		$(my_use_enable cron-boot boot) \
		$(my_use_enable minutely) \
		$(my_use_enable yearly) \
		$(my_use_enable yearly quarterly) \
		$(my_use_enable yearly semi_annually) \
		$(my_use_enable setgid) \
		--enable-persistent=yes
}
