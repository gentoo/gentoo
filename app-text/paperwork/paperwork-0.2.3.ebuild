# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="a personal document manager for scanned documents (and PDFs)"
HOMEPAGE="https://github.com/jflesch/paperwork"
SRC_URI="https://github.com/jflesch/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-text/poppler[introspection]
	dev-python/joblib[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pycountry[${PYTHON_USEDEP}]
	dev-python/pyenchant[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=dev-python/pyinsane-1.3.8[${PYTHON_USEDEP}]
	>=dev-python/pyocr-0.3.0[${PYTHON_USEDEP}]
	dev-python/python-levenshtein[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]
	<dev-python/whoosh-2.7.0[${PYTHON_USEDEP}]
	dev-util/glade[introspection,python]
	sci-libs/scikits_learn[${PYTHON_USEDEP}]
	sci-libs/scikits_image[${PYTHON_USEDEP}]
	virtual/python-imaging[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]"
DEPEND="${RDEPEND}"
