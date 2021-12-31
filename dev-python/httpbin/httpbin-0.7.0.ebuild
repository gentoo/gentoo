# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="HTTP Request and Response Service"
HOMEPAGE="https://github.com/postmanlabs/httpbin
	https://pypi.org/project/httpbin/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/brotlipy[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/itsdangerous[${PYTHON_USEDEP}]
	dev-python/markupsafe[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-0.14.1[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=(
	# do not import raven if it's not going to be used
	# (upstream removed it completely in git anyway)
	"${FILESDIR}"/httpbin-0.7.0-optional-raven.patch
	# fix tests with new versions of werkzeug
	"${FILESDIR}"/httpbin-0.7.0-test-werkzeug.patch
)

distutils_enable_tests unittest
