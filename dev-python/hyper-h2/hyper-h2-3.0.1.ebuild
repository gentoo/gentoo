# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy)

inherit distutils-r1

DESCRIPTION="HTTP/2 State-Machine based protocol implementation"
HOMEPAGE="https://python-hyper.org/h2/en/stable/ https://pypi.python.org/pypi/h2"
SRC_URI="https://github.com/python-hyper/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE=""

RDEPEND="
	>=dev-python/hyperframe-5.0.0[${PYTHON_USEDEP}]
	<dev-python/hyperframe-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/hpack-2.3.0[${PYTHON_USEDEP}]
	<dev-python/hpack-4.0.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/enum34-1.1.6[${PYTHON_USEDEP}]' python2_7)
	$(python_gen_cond_dep '<dev-python/enum34-2.0.0[${PYTHON_USEDEP}]' python2_7)
"
DEPEND="${RDEPEND}
"
