# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_4 python3_5 python3_6 )

inherit distutils-r1

MY_PN=xdot.py
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Interactive viewer for Graphviz dot files"
HOMEPAGE="https://github.com/jrfonseca/xdot.py"
SRC_URI="https://github.com/jrfonseca/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	media-gfx/graphviz
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	eapply_user

	# Don't require graphviz python(2) supprt, which xdot doesn't use. This allows xdot to support python3.
	# For more info, see https://bugs.gentoo.org/643126
	sed -i "/install_requires=\['graphviz'\],/d" setup.py || die
}
