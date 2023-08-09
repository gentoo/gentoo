# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..12} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="enables the changeset evolution feature of Mercurial"
HOMEPAGE="https://www.mercurial-scm.org/doc/evolution/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	>=dev-vcs/mercurial-4.8[${PYTHON_USEDEP}]
	$(python_gen_impl_dep sqlite)"
DEPEND="${RDEPEND}
	doc? (
		dev-python/sphinx
		media-gfx/imagemagick[svg]
		)"

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
