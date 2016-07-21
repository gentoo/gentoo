# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# snapshot extracted from git://git.savannah.gnu.org/gnulib.git using
# ./gnulib-tool --create-testdir --without-tests --dir=${PN} ${PN};
# cd ${PN}; ./configure; make maintainer-clean

EAPI=5

DESCRIPTION="Git merge driver for GNU style ChangeLog files"
HOMEPAGE="https://www.gnu.org/software/gnulib/"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${PN}"

src_prepare() {
	sed -n "/README/{h;:x;n;/^#/!{H;bx};g;s/\n*$//;s:/usr/local:${EPREFIX}/usr:g;p;q}" \
		gllib/git-merge-changelog.c >README || die
}
