# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )

MY_PN=xdot.py
EGIT_REPO_URI="https://github.com/jrfonseca/${MY_PN}"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
	SRC_URI=""
else
	KEYWORDS="~amd64 ~x86"
	MY_P="${MY_PN}-${PV}"
	S="${WORKDIR}/${MY_P}"
	SRC_URI="https://github.com/jrfonseca/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

inherit ${GIT_ECLASS} distutils-r1

DESCRIPTION="Interactive viewer for Graphviz dot files"
HOMEPAGE="https://github.com/jrfonseca/xdot.py"

LICENSE="LGPL-2+"
SLOT="0"

DEPEND="
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	media-gfx/graphviz
"
RDEPEND="${DEPEND}"

src_unpack() {
	default
	[[ $PV = 9999* ]] && git-r3_src_unpack
}

src_prepare() {
	eapply_user

	# Don't require graphviz python(2) supprt, which xdot doesn't use. This allows xdot to support python3.
	# For more info, see https://bugs.gentoo.org/643126
	sed -i "/install_requires=\['graphviz'\],/d" setup.py || die
}
