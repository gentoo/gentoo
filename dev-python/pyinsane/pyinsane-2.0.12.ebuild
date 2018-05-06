# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="Python implementation of the Sane API and abstration layer"
HOMEPAGE="https://github.com/openpaperwork/pyinsane"
SRC_URI="https://github.com/openpaperwork/pyinsane/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="media-gfx/sane-backends
	dev-python/pillow[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

RESTRICT="test" # Tests require at least one scanner with a flatbed and an ADF

python_prepare_all() {
	sed -e "/'nose>=1.0'/d" \
		-i setup.py || die
	distutils-r1_python_prepare_all

	# Upstream Makefile requires git checkout
	echo "version = \"${PV}\"" > pyinsane2/_version.py || die
}
