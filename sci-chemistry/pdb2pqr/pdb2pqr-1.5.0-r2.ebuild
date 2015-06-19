# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/pdb2pqr/pdb2pqr-1.5.0-r2.ebuild,v 1.11 2012/10/19 10:10:18 jlec Exp $

EAPI="3"

PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"
RESTRICT_PYTHON_ABIS="2.4 3.*"

inherit autotools eutils fortran-2 flag-o-matic python toolchain-funcs versionator

MY_PV=$(get_version_component_range 1-2)
MY_P="${PN}-${MY_PV}"

DESCRIPTION="An automated pipeline for performing Poisson-Boltzmann electrostatics calculations"
LICENSE="BSD"
HOMEPAGE="http://pdb2pqr.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

SLOT="0"
IUSE="doc examples opal"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/numpy
	sci-chemistry/openbabel
	opal? ( dev-python/zsi )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	fortran-2_pkg_setup
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.4.0-ldflags.patch
	epatch "${FILESDIR}"/${PN}-1.4.0-automagic.patch
	epatch "${FILESDIR}"/${PN}-1.4.0-install.patch
	sed '50,200s:CWD:DESTDIR:g' -i Makefile.am \
		|| die "Failed to fix Makefile.am"
	python_src_prepare
	preparation() {
		eautoreconf
	}
	python_execute_function -s preparation
}

src_configure() {
	# we need to compile the *.so as pic
	append-flags -fPIC
	FFLAGS="${FFLAGS} -fPIC"

	configuration() {
		# Avoid automagic to numeric
		NUMPY="${EPREFIX}/$(python_get_sitedir)" \
			F77="$(tc-getFC)" \
			econf \
			$(use_with opal)
	}
	python_execute_function -s configuration
}

src_compile() {
	compilation() {
		emake || die
	}
	python_execute_function -s compilation
}

src_test() {
	testing() {
		emake -j1 test \
			|| die "tests failed"
	}
	python_execute_function -s testing
}

src_install() {
	installation() {
		dodir $(python_get_sitedir)/${PN}
		emake -j1 DESTDIR="${ED}$(python_get_sitedir)/${PN}" \
			PREFIX=""  install || die "install failed"

		INPATH="$(python_get_sitedir)/${PN}"

		# generate pdb2pqr wrapper
		cat >> "${T}"/${PN}-$(python_get_version) <<-EOF
			#!/bin/sh
			$(PYTHON) ${EPREFIX}/${INPATH}/${PN}.py \$*
		EOF

		dobin "${T}"/${PN}-$(python_get_version) || die "Failed to install pdb2pqr wrapper."

		insinto "${INPATH}"
		doins __init__.py || \
			die "Setting up the pdb2pqr site-package failed."

		exeinto "${INPATH}"
		doexe ${PN}.py || die "Installing pdb2pqr failed."

		insinto "${INPATH}"/dat
		doins dat/* || die "Installing data failed."

		exeinto "${INPATH}"/extensions
		doexe extensions/* || \
			die "Failed to install extensions."

		insinto "${INPATH}"/src
		doins src/*.py || die "Installing of python scripts failed."

		exeinto "${INPATH}"/propka
		doexe propka/_propkalib.so || \
			die "Failed to install propka."

		insinto "${INPATH}"/propka
		doins propka/propkalib.py propka/__init__.py || \
			die "Failed to install propka."

		insinto "${INPATH}"/pdb2pka
		doins pdb2pka/*.{py,so,DAT,h} || \
			die "Failed to install pdb2pka."

		insinto "${INPATH}"/pdb2pka/
		doins pdb2pka/*.{py,so,DAT,h} || \
			die "Failed to install pdb2pka."
	}
	python_execute_function -s installation

	dosym ${PN}-$(python_get_version -f) /usr/bin/${PN}

	if use doc; then
		cd doc
		sh genpydoc.sh \
			|| die "genpydoc failed"
		dohtml -r *.html images pydoc \
			|| die "failed to install html docs"
		cd -
	fi

	if use examples; then
		insinto /usr/share/${PN}/
		doins -r examples || die "Failed to install examples."
	fi

	dodoc ChangeLog NEWS README AUTHORS || \
		die "Failed to install docs"
}

pkg_postinst() {
	python_mod_optimize ${PN}
}

pkg_postrm() {
	python_mod_cleanup ${PN}
}
