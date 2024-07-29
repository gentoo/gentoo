# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_PN=jinja2
PYTHON_COMPAT=( python3_{10..13} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="A full-featured template engine for Python"
HOMEPAGE="
	https://palletsprojects.com/p/jinja/
	https://github.com/pallets/jinja/
	https://pypi.org/project/Jinja2/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-python/markupsafe-2.0[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/sphinx-issues \
	dev-python/pallets-sphinx-themes
distutils_enable_tests pytest

# XXX: handle Babel better?

src_prepare() {
	local PATCHES=(
		# https://github.com/pallets/jinja/pull/1979
		"${FILESDIR}/${P}-py313.patch"
	)

	# avoid unnecessary dep on extra sphinxcontrib modules
	sed -i '/sphinxcontrib.log_cabinet/ d' docs/conf.py || die

	distutils-r1_src_prepare
}

pkg_postinst() {
	if ! has_version dev-python/Babel; then
		elog "For i18n support, please emerge dev-python/Babel."
	fi
}
