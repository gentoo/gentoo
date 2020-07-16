# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_7,3_8} )

inherit vim-plugin python-r1

MY_PN="iris.vim"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="vim plugin: mail client for vim"
HOMEPAGE="https://github.com/soywod/iris.vim"
SRC_URI="https://github.com/soywod/iris.vim/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	dev-python/imapclient
	${PYTHON_DEPS}"

S="${WORKDIR}/${MY_P}"

src_install() {
	mv api.py iris-api || die
	mv idle.py iris-idle || die
	sed -e 's#api\.py#iris-api#g;' -i autoload/iris/api.vim || die
	sed -e 's#idle\.py#iris-idle#g;' -i autoload/iris/idle.vim || die
	python_foreach_impl python_doscript iris-api
	python_foreach_impl python_doscript iris-idle

	vim-plugin_src_install
}
