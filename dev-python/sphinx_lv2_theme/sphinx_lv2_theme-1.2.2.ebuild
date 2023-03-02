# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Minimal pure-CSS Sphinx theme using the LV2 plugin documentation style"
HOMEPAGE="
	https://gitlab.com/lv2/sphinx_lv2_theme/
	https://pypi.org/project/sphinx-lv2-theme/
"
SRC_URI="https://gitlab.com/lv2/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86"
