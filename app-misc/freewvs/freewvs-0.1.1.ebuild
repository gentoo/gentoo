# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="Scans filesystem for known vulnerable web applications"
HOMEPAGE="https://freewvs.schokokeks.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( README.md )

pkg_postinst() {
	einfo To use freewvs you need to run
	einfo   update-freewvsdb
	einfo first. You should run this on a regular basis to update
	einfo the web application data, e.g. via a cronjob.
}
