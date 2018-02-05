# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

MY_P=${P/pywebdav/PyWebDAV}

DESCRIPTION="WebDAV server written in Python"
HOMEPAGE="https://pypi.python.org/pypi/PyWebDAV"
SRC_URI="https://pywebdav.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

python_install_all() {
	distutils-r1_python_install_all
	dodoc doc/{ARCHITECTURE,Changes,TODO,interface_class,walker}
}
