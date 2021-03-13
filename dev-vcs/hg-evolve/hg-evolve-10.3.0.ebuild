# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="enables the changeset evolution feature of Mercurial"
HOMEPAGE="https://www.mercurial-scm.org/doc/evolution/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	>=dev-vcs/mercurial-4.6[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )"

python_prepare_all() {
	rm hgext3rd/__init__.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs all
}

python_install_all() {
	distutils-r1_python_install_all

	if use doc; then
		dodoc -r html/
	fi
}
