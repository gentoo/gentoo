# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools

MYP=HepPDT-${PV}

DESCRIPTION="Data about each particle from the Review of Particle Properties"
HOMEPAGE="http://lcgapp.cern.ch/project/simu/HepPDT/"
SRC_URI="${HOMEPAGE}/download/${MYP}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYP}"

src_prepare() {
	# respect user flags
	sed -i \
		-e '/AC_SUBST(AM_CXXFLAGS)/d' \
		configure.ac || die
	# directories
	sed -i \
		-e 's:$(prefix)/data:$(datadir)/${PN}:g' \
		data/Makefile.am || die
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_test() {
	LD_LIBRARY_PATH="${S}/src/HepPDT:${S}/src/HepPID" \
		emake check MY_LD=-L SHEXT=so
}

src_install() {
	default
	use doc && mv "${ED}"usr/doc/* "${ED}"usr/share/doc/${PF}/
	use examples && mv "${ED}"usr/examples "${ED}"usr/share/doc/${PF}/
	rm -r "${ED}"usr/{doc,examples}
}
