# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Backend part of Paperwork (Python API, no UI)"
HOMEPAGE="https://gitlab.gnome.org/World/OpenPaperwork"

# Use pypi sdist due to AUTHORS.json which relies on git to generate a proper file
#
# Update from release hash at:
# https://gitlab.gnome.org/World/OpenPaperwork/paperwork/-/tags
#REL_HASH="3f51346f"
#SRC_URI="https://gitlab.gnome.org/World/OpenPaperwork/paperwork/-/archive/${PV}/paperwork-${PV}.tar.bz2
#	https://download.openpaper.work/data/paperwork/master_${REL_HASH}/data.tar.gz -> paperwork-data-${PV}.tar.gz"
#S=${WORKDIR}/paperwork-${PV}/${PN}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# openpaperwork-gtk: https://gitlab.gnome.org/World/OpenPaperwork/paperwork/-/work_items/1126
RDEPEND="
	app-text/openpaperwork-core[${PYTHON_USEDEP}]
	app-text/openpaperwork-gtk[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pycountry[${PYTHON_USEDEP}]
	dev-python/pyocr[${PYTHON_USEDEP}]
	dev-python/pypillowfight[${PYTHON_USEDEP}]
	dev-python/scikit-learn[${PYTHON_USEDEP}]
	dev-python/whoosh[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		media-libs/libinsane
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	# see pytest.ini in the repo
	epytest -o python_files='tests_*.py'
}
