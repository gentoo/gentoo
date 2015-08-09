# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="A set of additional compression profiles for app-arch/zpaq"
HOMEPAGE="http://mattmahoney.net/dc/zpaq.html"
SRC_URI="http://mattmahoney.net/dc/bwt_j3.zip
	http://mattmahoney.net/dc/bwt_slowmode1.zip
	http://mattmahoney.net/dc/exe_j1.zip
	http://mattmahoney.net/dc/jpg_test2.zip
	http://mattmahoney.net/dc/min.zip
	http://mattmahoney.net/dc/fast.cfg -> zpaq-fast.cfg
	http://mattmahoney.net/dc/mid.cfg -> zpaq-mid.cfg
	http://mattmahoney.net/dc/max.cfg -> zpaq-max.cfg
	http://mattmahoney.net/dc/bmp_j4c.zip
	http://mattmahoney.net/dc/lz1.zip
	http://mattmahoney.net/dc/lazy100.zip
	http://mattmahoney.net/dc/lazy210.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=">=app-arch/zpaq-6.19"

S=${WORKDIR}

src_unpack() {
	local x
	for x in ${A}; do
		if [[ ${x} == *.cfg ]]; then
			cp "${DISTDIR}"/${x} ${x#zpaq-} || die
		fi
	done

	default
}

src_configure() {
	sed \
		-e "/^pcomp zpaq/s:-m:-m${EPREFIX}/usr/share/zpaq/:" \
		-e "s:^pcomp zpaq:pcomp ${EPREFIX}/usr/bin/zpaq:" \
		-e "s:^pcomp \([^/]\):pcomp ${EPREFIX}/usr/lib/zpaq/\1:" \
		-i *.cfg || die

	local sources=( *.cpp )
	# (the following assignment flattens the array)
	progs=${sources[@]%.cpp}
}

src_compile() {
	tc-export CXX
	emake ${progs} || die
}

src_install() {
	exeinto /usr/lib/zpaq
	doexe ${progs} || die

	insinto /usr/share/zpaq
	doins *.cfg || die
}
