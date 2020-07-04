# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="A supersonic micro-framework for building cloud APIs"
HOMEPAGE="http://falconframework.org/ https://pypi.org/project/falcon/"
SRC_URI="https://github.com/racker/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cython"
RESTRICT="test"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]
	dev-python/python-mimeparse[${PYTHON_USEDEP}]
	cython? ( dev-python/cython[${PYTHON_USEDEP}] )"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

src_prepare() {
	if ! use cython; then
		sed -i -e 's/if with_cython:/if False:/' setup.py \
			|| die 'sed failed.'
	fi

	eapply_user
}
