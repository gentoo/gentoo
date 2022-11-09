# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A high-level Python library that makes it easier to use Apache Zookeeper"
HOMEPAGE="https://kazoo.readthedocs.org/ https://github.com/python-zk/kazoo/ https://pypi.org/project/kazoo/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="doc"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/graphviz[${PYTHON_USEDEP}]
		>=dev-python/objgraph-3.4.0[${PYTHON_USEDEP}]
		sys-cluster/zookeeper-bin
	)
"

distutils_enable_sphinx docs
distutils_enable_tests pytest

src_prepare() {
	# TODO
	sed -e 's:test_close:_&:' \
		-e 's:test_delete_operation:_&:' \
		-i kazoo/tests/test_cache.py || die
	distutils-r1_src_prepare
}

src_test() {
	local pkgver=$(best_version sys-cluster/zookeeper-bin)
	pkgver=${pkgver#sys-cluster/zookeeper-bin-}
	export ZOOKEEPER_VERSION=${pkgver%-r*}
	export ZOOKEEPER_PATH=${BROOT}/opt/zookeeper-bin
	distutils-r1_src_test
}

python_install_all() {
	local DOCS=( {CHANGES,CONTRIBUTING,README}.md )
	distutils-r1_python_install_all
}
