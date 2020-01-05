# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="API wrapper for Pushover"
HOMEPAGE="https://github.com/karanlyons/chump"
# PyPI tarballs currently don't contain docs
# https://github.com/karanlyons/chump/pull/10
# Releases are not tagged on GitHub
# https://github.com/karanlyons/chump/issues/9
SRC_URI="https://github.com/karanlyons/${PN}/archive/0cd59e14267858ab6623d7aa42badc6caa9b8edf.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"

python_prepare_all() {
	sed -i "/'sphinx.ext.intersphinx'/d" docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	# Force sphinx to use the standard theme
	use doc && READTHEDOCS=True emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
