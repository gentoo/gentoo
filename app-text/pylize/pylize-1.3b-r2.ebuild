# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Python HTML Slideshow Generator using HTML and CSS"
HOMEPAGE="http://www.chrisarndt.de/en/software/pylize/"
SRC_URI="http://www.chrisarndt.de/en/software/pylize/download/${P}.tar.bz2"

IUSE="doc"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="
	$(python_gen_cond_dep '
		dev-python/empy[${PYTHON_MULTI_USEDEP}]
		dev-python/pillow[${PYTHON_MULTI_USEDEP}]
	')"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-pillow.patch" )

python_configure() {
	set -- "${PYTHON}" configure.py
	echo "$@"
	"$@" || die
}

python_compile_all() {
	if use doc; then
		emake -C doc PYTHON="${PYTHON}" PYLIZE="../pylize"
	fi
}

python_install() {
	distutils-r1_python_install
	python_optimize "${ED%/}/usr/share/pylize"
}

python_install_all() {
	local DOCS=( Changelog README README.empy TODO )
	use doc && local HTML_DOCS=( doc/. )
	distutils-r1_python_install_all
}
