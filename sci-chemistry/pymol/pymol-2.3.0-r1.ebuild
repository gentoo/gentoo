# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 desktop eutils flag-o-matic xdg-utils

DESCRIPTION="A Python-extensible molecular graphics system"
HOMEPAGE="http://www.pymol.org/"
SRC_URI="
	https://dev.gentoo.org/~jlec/distfiles/${PN}-1.8.4.0.png.xz
	https://github.com/schrodinger/pymol-open-source/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
RESTRICT="mirror"
LICENSE="PSF-2.2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="web"

DEPEND="
	dev-libs/msgpack[cxx]
	dev-libs/mmtf-cpp
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pmw:py2[${PYTHON_USEDEP}]
	dev-python/pyopengl[${PYTHON_USEDEP}]
	dev-python/PyQt5[opengl,${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	media-libs/freetype:2
	media-libs/glew:0=
	media-libs/glm
	media-libs/libpng:0=
	media-video/mpeg-tools
	sys-libs/zlib
	!sci-chemistry/pymol-apbs-plugin[${PYTHON_USEDEP}]
	web? ( !dev-python/webpy[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}-open-source-${PV}

python_prepare_all() {
	sed \
		-e "s:\"/usr:\"${EPREFIX}/usr:g" \
		-e "/ext_comp_args.*+=/s:\[.*\]$:\[\]:g" \
		-e "/import/s:argparse:argparseX:g" \
		-i setup.py || die

	sed \
		-e "s:/opt/local:${EPREFIX}/usr:g" \
		-e '/ext_comp_args/s:\[.*\]:[]:g' \
		-i setup.py || die
	sed \
		-e "s:\['msgpackc'\]:\['msgpack'\]:g" \
		-i setup.py || die

	append-cxxflags -std=c++0x

	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install \
		--pymol-path="${EPREFIX}/usr/share/pymol"

	sed \
		-e '1d' \
		-e "/APBS_BINARY_LOCATION/s:None:\"${EPREFIX}/usr/bin/apbs\":g" \
		-e "/APBS_PSIZE_LOCATION/s:None:\"$(python_get_sitedir)/pdb2pqr/src/\":g" \
		-e "/APBS_PDB2PQR_LOCATION/s:None:\"$(python_get_sitedir)/pdb2pqr/\":g" \
		-i "${D}/$(python_get_sitedir)"/pmg_tk/startup/apbs_tools.py || die
}

python_install_all() {
	distutils-r1_python_install_all

	sed \
		-e '1i#!/usr/bin/env python' \
		"${D}/$(python_get_sitedir)"/pymol/__init__.py > "${T}"/${PN} || die

	python_foreach_impl python_doscript "${T}"/${PN}

	# These environment variables should not go in the wrapper script, or else
	# it will be impossible to use the PyMOL libraries from Python.
	cat >> "${T}"/20pymol <<- EOF
		PYMOL_PATH="${EPREFIX}/usr/share/pymol"
		PYMOL_DATA="${EPREFIX}/usr/share/pymol/data"
		PYMOL_SCRIPTS="${EPREFIX}/usr/share/pymol/scripts"
	EOF

	doenvd "${T}"/20pymol

	newicon "${WORKDIR}"/${PN}-1.8.4.0.png ${PN}.png
	make_desktop_entry ${PN} PyMol ${PN} \
		"Graphics;Education;Science;Chemistry;" \
		"MimeType=chemical/x-pdb;chemical/x-mdl-molfile;chemical/x-mol2;chemical/seq-aa-fasta;chemical/seq-na-fasta;chemical/x-xyz;chemical/x-mdl-sdf;"

	if ! use web; then
		rm -rf "${D}/$(python_get_sitedir)/web" || die
	fi

	rm -f "${ED}"/usr/share/${PN}/LICENSE || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	optfeature "Electrostatic calculations" sci-chemistry/apbs sci-chemistry/pdb2pqr
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
