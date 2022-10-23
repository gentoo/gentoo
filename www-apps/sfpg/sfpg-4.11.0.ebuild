# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

MY_PN="${PN^^}"
MY_PV="fd8fa70739d18d786e88f7ffa57e250e0e41af8f"

DESCRIPTION="A web gallery in one single PHP file"
HOMEPAGE="https://sye.dk/sfpg/"
SRC_URI="https://sye.dk/sfpg/Single_File_PHP_Gallery_${PV}.zip"
S="${WORKDIR}"

LICENSE="sfpg"
KEYWORDS="~amd64 ~x86"
RESTRICT="bindist mirror"

RDEPEND="
	dev-lang/php[gd]
	virtual/httpd-php
"

BDEPEND="app-arch/unzip"

need_httpd_cgi

DOCS=( "readme.txt" )

src_install() {
	webapp_src_preinst

	einstalldocs

	insinto "${MY_HTDOCSDIR}"
	doins index.php

	webapp_src_install
}

pkg_postinst() {
	webapp_pkg_postinst
}
