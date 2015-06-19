# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/git-bz/git-bz-9999.ebuild,v 1.11 2015/04/08 17:53:03 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )

inherit python-single-r1

#if LIVE
EGIT_REPO_URI="git://git.fishsoup.net/${PN}
	http://git.fishsoup.net/cgit/${PN}"
inherit git-r3
#endif

DESCRIPTION="Bugzilla subcommand for git"
HOMEPAGE="http://www.fishsoup.net/software/git-bz/"
SRC_URI="https://www.bitbucket.org/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-vcs/git"

#if LIVE
DEPEND="app-text/asciidoc
	app-text/xmlto"

KEYWORDS=
SRC_URI=
#endif

src_configure() {
	# custom script
	./configure --prefix="${EPREFIX}/usr" || die
}

#ifdef LIVE
src_compile() {
	emake ${PN}.1
}
#endif

src_install() {
	default
	python_fix_shebang "${ED%/}"/usr/bin/${PN}
}
