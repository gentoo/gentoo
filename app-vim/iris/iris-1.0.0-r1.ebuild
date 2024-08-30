# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit vim-plugin python-r1

DESCRIPTION="vim plugin: mail client for vim"
HOMEPAGE="https://github.com/soywod/iris.vim"
SRC_URI="https://github.com/soywod/iris.vim/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/iris.vim-${PV}"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/imapclient[${PYTHON_USEDEP}]
"

DOCS=( README.md CHANGELOG.md )

src_install() {
	mv api.py iris-api || die
	mv idle.py iris-idle || die
	sed -e 's#api\.py#iris-api#g;' -i autoload/iris/api.vim || die
	sed -e 's#idle\.py#iris-idle#g;' -i autoload/iris/idle.vim || die
	python_foreach_impl python_doscript iris-api
	python_foreach_impl python_doscript iris-idle

	vim-plugin_src_install
}
