# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} pypy )

inherit distutils-r1 eutils

DESCRIPTION="Filesystem abstraction layer"
HOMEPAGE="
	http://pypi.python.org/pypi/fs
	http://docs.pyfilesystem.org
	http://www.willmcgugan.com/tag/fs/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/dexml[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mako[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"

# Tries to access FUSE
RESTRICT=test

python_test() {
	nosetests --verbose || die
}

pkg_postinst() {
	optfeature "S3 support" dev-python/boto
	optfeature "SFTP support" dev-python/paramiko
	optfeature "Browser support" dev-python/wxpython
}
