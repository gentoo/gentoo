# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Create a GNU-style ChangeLog from subversion's svn log --xml output"
HOMEPAGE="https://arthurdejong.org/svn2cl/"
SRC_URI="https://arthurdejong.org/svn2cl/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~x86"

RDEPEND="dev-libs/libxslt
	dev-vcs/subversion"

PATCHES=( "${FILESDIR}/0.9-wrapper.patch" )

src_install() {
	newbin svn2cl.sh svn2cl
	insinto /usr/share/svn2cl
	doins svn2cl.xsl svn2html.xsl
	dodoc README NEWS TODO ChangeLog authors.xml svn2html.css
	doman svn2cl.1
}

pkg_postinst() {
	elog "You can find samples of svn2html.css and authors.xml in"
	elog "/usr/share/doc/${PF}/"
	elog "Read man page for details."
}
