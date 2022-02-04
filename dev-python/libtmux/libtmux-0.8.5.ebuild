# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} pypy3 )
inherit distutils-r1

DESCRIPTION="python api for tmux"
HOMEPAGE="https://libtmux.git-pull.com/"
SRC_URI="https://github.com/tmux-python/${PN}/archive/v${PV}.tar.gz -> ${PN}-v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"

RDEPEND=">=app-misc/tmux-3.0a"
BDEPEND="
	test? (
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	local issues="https://github.com/tmux-python/libtmux/issues/"
	sed -r -i "s|:issue:\`([[:digit:]]+)\`|\`issue \1 ${issues}\1\`|" CHANGES || die
	rm requirements/doc.txt || die

	distutils-r1_python_prepare_all
}
