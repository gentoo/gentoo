# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml
inherit distutils-r1

DESCRIPTION="CFFI bindings to the Argon2 password hashing library"
HOMEPAGE="https://github.com/hynek/argon2-cffi"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-python/argon2-cffi-bindings-21.2.0[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

DOCS=( AUTHORS.rst CHANGELOG.md FAQ.rst README.rst )

src_prepare() {
	# Patch the tool.flit.module.name entry in pyproject.toml to include
	# the "src" subfolder. This allows pyproject2setuppy to retrieve the
	# dynamic version and description correctly.
	sed -i -e 's:^name = "argon2":name = "src/argon2":' \
		"pyproject.toml" || die "Unable to patch package name"
	# Sphinx's conf.py uses importlib.metadata to determine the package
	# version. However, argon2-cffi is not installed when we try to build
	# the docs. Therefore, we patch the release version in conf.py.
	sed -i -e "/^release/s:= .*:= \"${PV}\":" \
		"docs/conf.py" || die "Unable to patch version in docs"
	distutils-r1_src_prepare
}

distutils_enable_sphinx docs \
	dev-python/furo \
	dev-python/sphinx-notfound-page
distutils_enable_tests pytest
