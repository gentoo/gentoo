# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Minimal pure-CSS Sphinx theme using the LV2 plugin documentation style"
HOMEPAGE="
	https://gitlab.com/lv2/sphinx_lv2_theme/
	https://pypi.org/project/sphinx-lv2-theme/
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~sparc x86"

src_prepare() {
	distutils-r1_src_prepare

	# https://gitlab.com/lv2/sphinx_lv2_theme/-/issues/4
	find -name '*.pyc' -delete || die
}
