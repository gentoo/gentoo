# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/systemd-cron/systemd-cron-1.5.3.ebuild,v 1.1 2015/07/18 15:48:50 rich0 Exp $

EAPI=5
PYTHON_COMPAT=( pypy3 python{3_3,3_4} )
inherit eutils python-single-r1 systemd

DESCRIPTION="systemd units to provide minimal cron daemon functionality by running scripts in cron directories"
HOMEPAGE="https://github.com/systemd-cron/systemd-cron/"
SRC_URI="https://github.com/systemd-cron/${PN}/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cron-boot etc-crontab-systemd minutely setgid yearly"

RDEPEND=">=sys-apps/systemd-217
	     sys-apps/debianutils
	     !etc-crontab-systemd? ( !sys-process/dcron )
	     ${PYTHON_DEPS}
		 sys-process/cronbase"

DEPEND="sys-process/cronbase"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	python_fix_shebang --force "${S}/src/bin"

	sed -i \
		-e 's/^crontab/crontab-systemd/' \
		-e 's/^CRONTAB/CRONTAB-SYSTEMD/' \
		-- "${S}/src/man/crontab."{1,5}".in" || die

	sed -i \
		-e 's!/crontab$!/crontab-systemd!' \
		-e 's!/crontab\(\.[15]\)$!/crontab-systemd\1!' \
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
		$(my_use_enable cron-boot boot) \
		$(my_use_enable minutely) \
		$(my_use_enable yearly) \
		$(my_use_enable yearly quarterly) \
		$(my_use_enable yearly semi_annually) \
		$(my_use_enable setgid) \
		--enable-persistent=yes
}
