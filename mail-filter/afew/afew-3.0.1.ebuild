# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1 pypi

DESCRIPTION="Initial tagging script for Notmuch"
HOMEPAGE="https://github.com/afewmail/afew"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/dkimpy[${PYTHON_USEDEP}]
		net-mail/notmuch[python,${PYTHON_USEDEP}]
	')"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/sphinx[${PYTHON_USEDEP}]
	')
	test? (
		$(python_gen_cond_dep '
			dev-python/freezegun[${PYTHON_USEDEP}]
		')
	)"

DOCS=( "README.rst" )

distutils_enable_tests pytest

python_prepare_all() {
	sed -r \
		-e "s/^([[:space:]]+)use_scm_version=.*,$/\1version='${PV}',/" \
		-e "/^([[:space:]]+)setup_requires=.*,$/d" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	esetup.py build_sphinx -b man --build-dir=docs/build
	use doc && esetup.py build_sphinx -b html --build-dir=docs/build
}

python_install_all() {
	doman docs/build/man/*
	dodoc afew/defaults/afew.config
	use doc && HTML_DOCS=( docs/build/html/. )
	einstalldocs
}
