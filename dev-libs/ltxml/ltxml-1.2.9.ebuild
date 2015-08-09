# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit multilib toolchain-funcs

DESCRIPTION="Integrated set of XML tools and a developers tool-kit with C API"
HOMEPAGE="http://www.ltg.ed.ac.uk/software/xml/"
SRC_URI=ftp://ftp.cogsci.ed.ac.uk/pub/LTXML/${P}.tar.gz

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND=""

PV_MAJ="${PV:0:1}${PV:2:1}"

S=${WORKDIR}/${P}/XML

pkg_setup() {
	tc-export AR
}

src_prepare() {
	sed -e '/CFLAGS=/s:-g::' \
		-e '/CFLAGS=/s:-O2::' \
		-i configure || die
	sed -e 's/ar rv/$(AR) rv/' -i src/Makefile.sub.in || die
}

src_compile() {
	emake all
}

src_install() {
	emake -j1 install \
		datadir="${D}"/usr/$(get_libdir)/${PN}${PV_MAJ} \
		libdir="${D}"/usr/$(get_libdir) \
		prefix="${D}"/usr
}
