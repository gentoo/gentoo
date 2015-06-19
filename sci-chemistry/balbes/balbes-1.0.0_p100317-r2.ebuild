# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/balbes/balbes-1.0.0_p100317-r2.ebuild,v 1.4 2012/10/19 09:39:51 jlec Exp $

EAPI=3

CCP4VER="6.1.3"
PYTHON_DEPEND="2"

inherit eutils fortran-2 python toolchain-funcs

DESCRIPTION="Automated molecular replacement (MR) pipeline"
HOMEPAGE="http://www.ysbl.york.ac.uk/~fei/balbes/index.html"
SRC_URI="
	mirror://gentoo/${P}.tar.gz
	ftp://ftp.ccp4.ac.uk/ccp4/${CCP4VER}/ccp4-${CCP4VER}-core-src.tar.gz"

SLOT="0"
LICENSE="ccp4"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

# bundled PyXML is modified and cannot be replaced

COMMON_DEPEND="sci-libs/ccp4-libs"
RDEPEND="${COMMON_DEPEND}
	~sci-libs/balbes-db-${CCP4VER}
	!<=sci-chemistry/ccp4-apps-6.1.3-r1"
DEPEND="${COMMON_DEPEND}"

S="${WORKDIR}"/src

pkg_setup() {
	fortran-2_pkg_setup
	python_set_active_version 2
}

src_unpack() {
	unpack ${P}.tar.gz
	tar xvzf "${DISTDIR}"/ccp4-${CCP4VER}-core-src.tar.gz \
		ccp4-${CCP4VER}/share/balbes/BALBES_0.0.1/bin_py \
		ccp4-${CCP4VER}/share/balbes/BALBES_0.0.1/PyXML-0.8.4
	python_convert_shebangs 2 "${WORKDIR}"/ccp4-${CCP4VER}/share/balbes/BALBES_0.0.1/bin_py/balbes
}

src_prepare() {
	mkdir "${WORKDIR}"/bin || die
	epatch "${FILESDIR}"/${PV}-makefile.patch
	cd "${WORKDIR}"/ccp4-${CCP4VER}/share/balbes/BALBES_0.0.1/
	epatch "${FILESDIR}"/pyxml-0.8.4-python-2.6.patch
}

src_compile() {
	emake \
		BLANC_FORT="$(tc-getFC) ${FFLAGS}" || die
	cd "${WORKDIR}"/ccp4-${CCP4VER}/share/balbes/BALBES_0.0.1/PyXML-0.8.4
	find build -delete
	$(PYTHON) setup.py build
	find xml/xslt test -delete
}

src_install() {
	insinto /usr/share/balbes/BALBES_0.0.1/
	doins -r \
		 "${WORKDIR}"/ccp4-${CCP4VER}/share/balbes/BALBES_0.0.1/bin_py \
		 "${WORKDIR}"/ccp4-${CCP4VER}/share/balbes/BALBES_0.0.1/PyXML-0.8.4 || die
	dobin \
		"${WORKDIR}"/bin/* \
		"${WORKDIR}"/ccp4-${CCP4VER}/share/balbes/BALBES_0.0.1/bin_py/balbes \
		|| die
}

pkg_postinst() {
	python_mod_optimize /usr/share/balbes/BALBES_0.0.1/{bin_py,PyXML-0.8.4}
}

pkg_postrm() {
	python_mod_cleanup /usr/share/balbes/BALBES_0.0.1/{bin_py,PyXML-0.8.4}
}
