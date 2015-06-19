# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/git-merge-changelog/git-merge-changelog-20140223.ebuild,v 1.2 2015/05/28 13:47:34 vapier Exp $

# snapshot extracted from git://git.savannah.gnu.org/gnulib.git using
# ./gnulib-tool --create-testdir --without-tests --dir=${PN} ${PN};
# cd ${PN}; ./configure; make maintainer-clean

EAPI=5

DESCRIPTION="Git merge driver for GNU style ChangeLog files"
HOMEPAGE="http://www.gnu.org/software/gnulib/"
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${PN}"

src_prepare() {
	sed -n "/README/{h;:x;n;/^#/!{H;bx};g;s/\n*$//;s:/usr/local:${EPREFIX}/usr:g;p;q}" \
		gllib/git-merge-changelog.c >README || die
}
