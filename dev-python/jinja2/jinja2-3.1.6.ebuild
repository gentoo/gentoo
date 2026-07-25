# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_PN=jinja2
PYPI_VERIFY_REPO=https://github.com/pallets/jinja
PYTHON_COMPAT=( python3_{11..15} pypy3_11 )
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
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-python/markupsafe-2.0[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/sphinx-issues \
	dev-python/pallets-sphinx-themes

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

# XXX: handle Babel better?

src_prepare() {
	# avoid unnecessary dep on extra sphinxcontrib modules
	sed -i '/sphinxcontrib.log_cabinet/ d' docs/conf.py || die

	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_IGNORE=()
	if ! has_version "dev-python/trio[${PYTHON_USEDEP}]"; then
		EPYTEST_IGNORE+=(
			tests/test_async.py
			tests/test_async_filters.py
		)
	fi

	epytest
}

pkg_postinst() {
	if ! has_version dev-python/babel; then
		elog "For i18n support, please emerge dev-python/babel."
	fi
}
