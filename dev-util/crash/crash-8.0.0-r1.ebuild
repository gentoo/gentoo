# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/crash-utility/crash.git"
	SRC_URI="http://ftp.gnu.org/gnu/gdb/gdb-7.6.tar.gz"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/crash-utility/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		https://dev.gentoo.org/~dlan/distfiles/${CATEGORY}/${PN}/${PN}-8.0.0-patches-1.tar.xz
		mirror://gnu/gdb/gdb-10.2.tar.gz"
	KEYWORDS="-* ~alpha ~amd64 ~arm ~ia64 ~ppc64 ~s390 ~x86"
fi

DESCRIPTION="Red Hat crash utility; used for analyzing kernel core dumps"
HOMEPAGE="https://crash-utility.github.io/"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
# there is no "make test" target, but there is a test.c so the automatic
# make rules catch it and tests fail
RESTRICT="test"

PATCHES=( "${WORKDIR}"/${P}-patches/ )

src_prepare() {
	default
	sed -i -e "s|ar -rs|\${AR} -rs|g" Makefile || die
	ln -s "${DISTDIR}"/gdb-10.2.tar.gz . || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}
