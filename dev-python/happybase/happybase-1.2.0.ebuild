# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

COMMIT_HASH="f5b6d104140c2be93e4175c0c844aaf094eb43da"

DESCRIPTION="A developer-friendly Python library to interact with Apache HBase"
HOMEPAGE="https://github.com/python-happybase/happybase https://happybase.readthedocs.io/"
SRC_URI="
	https://github.com/python-happybase/happybase/archive/${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="MIT Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/thriftpy2[${PYTHON_USEDEP}]
"

# tests require a running thrift server
RESTRICT="test"

distutils_enable_tests pytest
