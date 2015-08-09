# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils webapp

DESCRIPTION="WWW interface to a CVS tree"
HOMEPAGE="http://www.freebsd.org/projects/cvsweb.html"
SRC_URI="ftp://ftp.freebsd.org/pub/FreeBSD/ports/local-distfiles/scop/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~ppc sparc x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.8
	>=dev-vcs/cvs-1.11
	>=dev-vcs/rcs-5.7
	>=dev-perl/URI-1.28
	dev-perl/IPC-Run
	dev-perl/MIME-Types
	dev-perl/String-Ediff
	>=dev-vcs/cvsgraph-1.4.0
	>=app-text/enscript-1.6.3"

src_prepare() {
	epatch "${FILESDIR}/${P}-perl518.patch"
}

src_install() {
	webapp_src_preinst

	cp cvsweb.conf "${D}"/${MY_HOSTROOTDIR}
	cp css/cvsweb.css "${D}"/${MY_HTDOCSDIR}
	exeinto ${MY_CGIBINDIR}
	doexe cvsweb.cgi
	chmod +x "${D}"/${MY_CGIBINDIR}/cvsweb.cgi

	dodoc README TODO NEWS ChangeLog

	webapp_hook_script "${FILESDIR}"/reconfig
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
