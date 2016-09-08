# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit webapp

DESCRIPTION="A Python 3 implementation for client-side web programming"
HOMEPAGE="http://www.brython.info"
SRC_URI="https://github.com/${PN}-dev/${PN}/archive/${PV}.zip -> ${P}.zip"

LICENSE="BSD"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="dev-lang/python:*"

DEPEND="${RDEPEND}"

need_httpd_cgi

src_install() {
	dodoc LICENCE.txt README.md
	rm -v LICENCE.txt README.md bower.json .{git*,tra*} server.py || die

	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_src_install
}
