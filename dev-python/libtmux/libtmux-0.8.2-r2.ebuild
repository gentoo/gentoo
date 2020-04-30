# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} pypy3 )
DISTUTILS_USE_SETUPTOOLS=bdepend
inherit distutils-r1

DESCRIPTION="python api for tmux"
HOMEPAGE="https://libtmux.git-pull.com/"
SRC_URI="https://github.com/tmux-python/${PN}/archive/v${PV}.tar.gz -> ${PN}-v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND=">=app-misc/tmux-3.0a"

PATCHES=(
	"${FILESDIR}/libtmux-0.8.2-tests.patch"
)

distutils_enable_tests pytest
distutils_enable_sphinx doc \
	dev-python/alagitpull \
	dev-python/docutils

python_prepare_all() {
	# avoid a dependency on sphinx_issues
	local issues="https://github.com/tmux-python/libtmux/issues/"
	sed -i "s:'sphinx_issues',::" doc/conf.py || die
	sed -r -i "s|:issue:\`([[:digit:]]+)\`|\`issue \1 ${issues}\1\`|" CHANGES || die
	rm requirements/doc.txt || die

	distutils-r1_python_prepare_all
}
