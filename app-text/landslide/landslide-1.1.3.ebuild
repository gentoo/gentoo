# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Landslide generates a slideshow using the slides that power the html5-slides presentation"
HOMEPAGE="https://github.com/adamzap/landslide"
SRC_URI="https://github.com/adamzap/landslide/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

DEPEND=""
RDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	"

python_install_all() {
	use examples && EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
