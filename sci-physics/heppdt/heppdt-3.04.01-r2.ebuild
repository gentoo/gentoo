# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Data about each particle from the Review of Particle Properties"
HOMEPAGE="http://lcgapp.cern.ch/project/simu/HepPDT/"
SRC_URI="http://lcgapp.cern.ch/project/simu/HepPDT/download/HepPDT-${PV}.tar.gz"
S=${WORKDIR}/HepPDT-${PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples static-libs"

src_prepare() {
	default
	# respect user flags
	sed -i configure.ac -e '/AC_SUBST(AM_CXXFLAGS)/d' || die
	# directories
	sed -i data/Makefile.am -e 's:$(prefix)/data:$(datadir)/${PN}:g' || die
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

	if use doc; then
		mv "${ED}"/usr/doc/* "${ED}"/usr/share/doc/${PF}/ || die
	fi
	if use examples; then
		mv "${ED}"/usr/examples "${ED}"/usr/share/doc/${PF}/ || die
		docompress -x /usr/share/doc/${PF}/examples
	fi
	rm -rf "${ED}"/usr/{doc,examples} || die
}
