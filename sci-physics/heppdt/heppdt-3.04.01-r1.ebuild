# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MY_P=HepPDT-${PV}

DESCRIPTION="Data about each particle from the Review of Particle Properties"
HOMEPAGE="http://lcgapp.cern.ch/project/simu/HepPDT/"
SRC_URI="${HOMEPAGE}/download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
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

	if use doc; then
		mv "${ED%/}"/usr/doc/* "${ED%/}"/usr/share/doc/${PF}/ || die
	fi
	if use examples; then
		mv "${ED%/}"/usr/examples "${ED%/}"/usr/share/doc/${PF}/ || die
		docompress -x /usr/share/doc/${PF}/examples
	fi
	rm -rf "${ED%/}"/usr/{doc,examples} || die
}
