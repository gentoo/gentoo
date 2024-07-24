# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WEBAPP_MANUAL_SLOT="yes"
inherit webapp

DESCRIPTION="Web frontend to symon"
HOMEPAGE="https://www.xs4all.nl/~wpd/symon/"
SRC_URI="https://www.xs4all.nl/~wpd/symon/philes/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"

RDEPEND="
	net-analyzer/rrdtool
	virtual/httpd-php
"

need_httpd_cgi

src_install() {
	webapp_src_preinst

	dodoc CHANGELOG README
	docinto layouts
	dodoc symon/*.layout

	dodir "${MY_HOSTROOTDIR}"/syweb/cache
	insinto "${MY_HOSTROOTDIR}"/syweb
	doins symon/hifn_test.layout
	webapp_serverowned "${MY_HOSTROOTDIR}"/syweb/cache
	insinto "${MY_HTDOCSDIR}"
	doins -r htdocs/syweb/*
	webapp_configfile "${MY_HTDOCSDIR}"/setup.inc
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_hook_script "${FILESDIR}"/reconfig

	webapp_src_install
}
