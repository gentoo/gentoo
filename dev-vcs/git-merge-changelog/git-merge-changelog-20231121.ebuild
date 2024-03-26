# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# snapshot extracted from git://git.savannah.gnu.org/gnulib.git using
# ./gnulib-tool --create-testdir --without-tests --dir=${PN} ${PN};
# cd ${PN}; ./configure; make maintainer-clean

EAPI=8

DESCRIPTION="Git merge driver for GNU style ChangeLog files"
HOMEPAGE="https://www.gnu.org/software/gnulib/"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Suppress false positive QA warnings #923767
QA_CONFIG_IMPL_DECL_SKIP=( MIN static_assert unreachable )

src_install() {
	emake DESTDIR="${D}" install
	sed -n "/README/{h;:x;n;/^#/!{H;bx;};g;s/\n*$//;\
		s:/usr/local:${EPREFIX}/usr:g;p;q;}" gllib/git-merge-changelog.c \
		| newdoc - README; assert
}
