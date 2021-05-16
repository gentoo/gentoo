# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Visualization tool for Git repositories"
HOMEPAGE="https://github.com/git-big-picture/git-big-picture"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# No need for "[python]" or "[${PYTHON_USEDEP}]" with any of these
# since they are invoked using subprocess
RDEPEND="
	dev-vcs/git
	media-gfx/graphviz[svg]
"

distutils_enable_tests pytest

src_prepare() {
	mv test.py test_some.py || die  # help pytest with test discovery
	default
}
