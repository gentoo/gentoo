# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/gitstats/gitstats-0_pre131024.ebuild,v 1.2 2015/04/08 17:53:03 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="Statistics generator for git"
HOMEPAGE="http://gitstats.sourceforge.net/"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sci-visualization/gnuplot[gd]
	dev-vcs/git"
DEPEND=""

src_prepare() {
	sed \
		-e "s:basedir = os.path.dirname(os.path.abspath(__file__)):basedir = '${EPREFIX}/usr/share/gitstats':g" \
		-i gitstats || die "failed to fix static files path"
}

src_compile() {
	:;
}

src_install() {
	emake PREFIX="${D}"/usr VERSION="${PV}" install
	dodoc doc/{README,*.txt}
	python_replicate_script "${ED}"/usr/bin/${PN}
}
