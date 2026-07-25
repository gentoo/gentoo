# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 optfeature pypi

DESCRIPTION="A generator for Rust/Cargo ebuilds written in Python"
HOMEPAGE="
	https://github.com/gentoo/pycargoebuild/
	https://pypi.org/project/pycargoebuild/
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64"

RDEPEND="
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/license-expression[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

pkg_postinst() {
	optfeature "parallel download support" net-misc/aria2
}
