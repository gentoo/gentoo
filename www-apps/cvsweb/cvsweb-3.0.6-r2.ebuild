# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="WWW interface to a CVS tree"
HOMEPAGE="http://www.freebsd.org/projects/cvsweb.html"
SRC_URI="ftp://ftp.freebsd.org/pub/FreeBSD/ports/local-distfiles/scop/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~ppc sparc x86"

RDEPEND="
	>=app-text/enscript-1.6.3
	>=dev-lang/perl-5.8
	dev-perl/IPC-Run
	dev-perl/MIME-Types
	dev-perl/String-Ediff
	>=dev-perl/URI-1.28
	>=dev-vcs/cvs-1.11
	>=dev-vcs/cvsgraph-1.4.0
	>=dev-vcs/rcs-5.7
"

PATCHES=(
	"${FILESDIR}"/${P}-perl518.patch
)

src_install() {
	webapp_src_preinst

	cp cvsweb.conf "${ED}"/${MY_HOSTROOTDIR} || die
	cp css/cvsweb.css "${ED}"/${MY_HTDOCSDIR} || die
	exeinto ${MY_CGIBINDIR}
	doexe cvsweb.cgi
	fperms +x ${MY_CGIBINDIR}/cvsweb.cgi

	dodoc README TODO NEWS ChangeLog

	webapp_hook_script "${FILESDIR}"/reconfig
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
