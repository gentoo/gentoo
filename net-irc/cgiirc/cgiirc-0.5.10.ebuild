# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/cgiirc/cgiirc-0.5.10.ebuild,v 1.1 2013/09/03 21:29:18 creffett Exp $
EAPI=5

inherit webapp eutils

DESCRIPTION="A perl/CGI program to use IRC from a web browser"
HOMEPAGE="http://cgiirc.org/"
SRC_URI="http://cgiirc.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

need_httpd_cgi

pkg_setup() {
	webapp_pkg_setup
	elog "Note that file locations have changed."
	elog "CGI:IRC will be installed into cgi-bin/${P}"
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	ecvs_clean
}

src_install() {
	webapp_src_preinst

	local docs="README cgiirc.config.full ipaccess.example"

	dodoc docs/{CHANGES,TODO} ${docs}
	dohtml docs/help.html
	rm -rf docs/ ${docs}

	insinto "${MY_CGIBINDIR}"/${P}
	doins -r .
	fperms +x "${MY_CGIBINDIR}"/${P}/irc.cgi

	webapp_configfile "${MY_CGIBINDIR}"/${P}/cgiirc.config
	webapp_src_install
}
