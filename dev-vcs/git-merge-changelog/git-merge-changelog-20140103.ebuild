# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Git merge driver for GNU style ChangeLog files"
HOMEPAGE="http://www.gnu.org/software/gnulib/"
# snapshot extracted from git://git.savannah.gnu.org/gnulib.git using
# ./gnulib-tool --create-testdir --without-tests --dir=${PN} ${PN};
# cd ${PN}; ./configure; make maintainer-clean
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}"

src_prepare() {
	sed -n '/README/{h;:x;n;/^#/!{H;bx};g;s/\n*$//;s:/usr/local:/usr:g;p;q}' \
		gllib/git-merge-changelog.c >README || die
}
