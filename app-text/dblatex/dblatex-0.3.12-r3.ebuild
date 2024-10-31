# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Transform DocBook using TeX macros"
HOMEPAGE="https://dblatex.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/dblatex/dblatex/${P}/${PN}3-${PV}.tar.bz2"
S="${WORKDIR}/${PN}3-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="inkscape test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-text/docbook-xml-dtd:4.5
	dev-libs/kpathsea
	dev-libs/libxslt
	dev-texlive/texlive-fontutils
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
	dev-texlive/texlive-latexrecommended
	dev-texlive/texlive-mathscience
	dev-texlive/texlive-pictures
	dev-texlive/texlive-xetex
	gnome-base/librsvg
	media-gfx/imagemagick
	>=media-gfx/fig2dev-3.2.9-r1
	inkscape? ( media-gfx/inkscape )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${RDEPEND}
	test? ( ~${CATEGORY}/${P}[${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}/${PN}-0.3.11-path-logging.patch"
	"${FILESDIR}/${PN}-0.3.11-setup.patch"
	"${FILESDIR}/${PN}-0.3.11-encode.patch"
	"${FILESDIR}/${P}-replace-imp-by-importlib.patch"
	"${FILESDIR}/${P}-adjust-submodule-imports.patch"
)

python_prepare_all() {
	# Manual page is precomressed, but we will use our own compression later.
	gunzip docs/manpage/dblatex.1.gz || die
	if use inkscape; then
		# If we use inscape we want to make dblatex compatible with v1.0
		eapply "${FILESDIR}/${PN}-0.3.11-inkscape-1.0.patch"
	else
		# If we don't have inkscape we need to use an alternative SVG converter
		eapply "${FILESDIR}/${PN}-0.3.11-no-inkscape-dependency.patch"
	fi

	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install

	# After migrating to PEP517 setuptool's distutils behaves a bit differently.
	# Rather than rewriting the entire build setup we follow Debian's path with
	# a predefined script.
	python_newscript - dblatex <<-EOF
		#!${EPREFIX}/usr/bin/python
		import sys
		import os

		package_base = r"${EPREFIX}/usr/share/dblatex"

		from dbtexmf.dblatex import dblatex
		dblatex.main(base=package_base)
	EOF
}

python_install_all() {
	distutils-r1_python_install_all

	# Move package documentation to a folder name containing version number
	mv "${ED}"/usr/share/doc/${PN} "${ED}"/usr/share/doc/${PF} || die
}

python_test() {
	emake -C tests/mathml
}
