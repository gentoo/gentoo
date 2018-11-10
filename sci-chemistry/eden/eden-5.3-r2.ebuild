# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils multilib python-r1 toolchain-funcs

MY_P="${PN}_V${PV}"

DESCRIPTION="A crystallographic real-space electron-density refinement & optimization program"
HOMEPAGE="http://www.gromacs.org/pipermail/eden-users/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="double-precision"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	sci-libs/fftw:2.1
	sci-libs/gsl
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}"

SRC="${S}/source"

pkg_setup() {
	export EDENHOME="${EPREFIX}/usr/$(get_libdir)/${PN}"
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-makefile-fixes.patch \
		"${FILESDIR}"/${P}-impl-dec.patch \
		"${FILESDIR}"/${P}-format-security.patch

	sed -i \
		-e "s:^\(FFTW.*=\).*:\1 ${EPREFIX}/usr:g" \
		-e "s:^\(LIB.*=.*\$(FFTW)/\).*:\1$(get_libdir):g" \
		-e "s:^\(BIN.*=\).*:\1 ${D}usr/bin:g" \
		-e "s:^\(CFLAGS.*=\).*:\1 ${CFLAGS}:g" \
		-e "s:-lgsl -lgslcblas:$($(tc-getPKG_CONFIG) --libs gsl):g" \
		${SRC}/Makefile || die

	if ! use double-precision; then
		sed -i -e "s:^\(DOUBLESWITCH.*=\).*:\1 OFF:g" ${SRC}/Makefile || die
		EDEN_EXE="s${PN}"
	else
		EDEN_EXE="d${PN}"
	fi
}

src_compile() {
	emake CC=$(tc-getCC) -C ${SRC}
}

src_install() {
	emake -C ${SRC} install

	python_foreach_impl python_newscript python/${PN}.py i${PN}
	python_foreach_impl python_domodule python/FileListDialog.py

	rm python/*py || die
	insinto ${EDENHOME}/python
	doins python/*

	insinto ${EDENHOME}/help
	doins help/*

	insinto ${EDENHOME}/tools
	doins tools/*

	dodoc manual/UserManual.pdf

	cat >> "${T}"/60${PN} <<- EOF
	EDENHOME="${EDENHOME}"
	EOF

	doenvd "${T}"/60${PN}

	dosym ${EDEN_EXE} /usr/bin/${PN}
}
