# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="CLI for extracting streams from various websites to a video player of your choice"
HOMEPAGE="https://streamlink.github.io/"
EGIT_REPO_URI="https://github.com/${PN}/${PN}"

PYTHON_COMPAT=( python{2_7,3_{4,5}} )
inherit distutils-r1

KEYWORDS=""
LICENSE="BSD-2"
SLOT="0"
IUSE="doc test"

RDEPEND="dev-python/pycrypto[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	virtual/python-singledispatch[${PYTHON_USEDEP}]
	media-video/rtmpdump"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( ${RDEPEND} )"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
