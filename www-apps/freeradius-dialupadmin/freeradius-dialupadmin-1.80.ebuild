# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils webapp
MY_FREERADIUS_PV="2.1.1"

DESCRIPTION="Web administration interface of freeradius server"
SRC_URI="ftp://ftp.freeradius.org/pub/radius/freeradius-server-${MY_FREERADIUS_PV}.tar.gz"
HOMEPAGE="http://www.freeradius.org/dialupadmin.html"

KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
LICENSE="GPL-2"

DEPEND="sys-apps/findutils
	sys-apps/sed"
RDEPEND="dev-lang/php
	dev-perl/Date-Manip
	>=net-dialup/freeradius-${MY_FREERADIUS_PV}"

S="${WORKDIR}/freeradius-server-${MY_FREERADIUS_PV}/dialup_admin"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}/${P}-gentoo.patch"
	epatch "${FILESDIR}/${P}-tmpfile.patch"

	sed -i -e 's:/usr/local:/usr:' \
		-e 's:/usr/etc/raddb:${general_raddb_dir}:' \
		-e 's:/usr/radiusd::' \
			conf/admin.conf
	sed -i -e 's:/usr/local:/usr:' bin/*

	#rename files .php3 -> .php
	(find . -iname '*.php3' | (
		local PHPFILE
		while read PHPFILE; do
			mv "${PHPFILE}" "${PHPFILE/.php3/.php}"
		done
	)) && \
	(find . -type f | xargs sed -i -e 's:[.]php3:.php:g') || \
		die "failed to replace php3 with php"

	# fix dangling ../ to deal with the way webapp-config installs files
	find . -name '*.php' | xargs sed -i \
		-e 's:../conf/:../../conf/:' \
		-e 's:../html/:../../html/:' \
		-e 's:../lib/:../../lib/:'
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r htdocs/*
	insinto "${MY_HOSTROOTDIR}"
	doins -r conf html lib
	exeinto "${MY_HOSTROOTDIR}/bin"
	dodoc bin/*.cron bin/Changelog*
	rm bin/*.cron bin/Changelog*
	doexe bin/*

	insinto "${MY_SQLSCRIPTSDIR}"
	doins -r sql/*

	dodoc Changelog README doc/*

	webapp_hook_script "${FILESDIR}/setrootpath"

	cd "${D}/${MY_HOSTROOTDIR}"
	local CONFFILE
	for CONFFILE in conf/* ; do
		webapp_configfile "${MY_HOSTROOTDIR}/${CONFFILE}"
		webapp_serverowned "${MY_HOSTROOTDIR}/${CONFFILE}"
	done

	webapp_src_install
}
