# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

# Breaks installation of /usr/bin/dblatex, bug #906788
#DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Transform DocBook using TeX macros"
HOMEPAGE="http://dblatex.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/dblatex/dblatex/${P}/${PN}3-${PV}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="inkscape test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-text/docbook-xml-dtd:4.5
	dev-libs/kpathsea
	dev-libs/libxslt
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
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}
	test? ( ~${CATEGORY}/${P} )"

S="${WORKDIR}/${PN}3-${PV}"

PATCHES=(
	 "${FILESDIR}/${PN}-0.3.11-path-logging.patch"
	 "${FILESDIR}/${PN}-0.3.11-setup.patch"
	 "${FILESDIR}/${PN}-0.3.11-encode.patch"
)

python_prepare_all() {
	# Manual page is precomressed, but we will use our own compression later.
	gunzip docs/manpage/dblatex.1.gz || die
	# If we dont have inkscape we need to use an alternative SVG converter
	use inkscape || eapply "${FILESDIR}/${PN}-0.3.11-no-inkscape-dependency.patch"
	# If we use inscape however we want to make dblatex compatible with v1.0
	use inkscape && eapply "${FILESDIR}/${PN}-0.3.11-inkscape-1.0.patch"
	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	# Move package documentation to a folder name containing version number
	mv "${D}"/usr/share/doc/${PN} "${D}"/usr/share/doc/${PF} || die
}

python_test_all() {
	emake -C tests/mathml
}
