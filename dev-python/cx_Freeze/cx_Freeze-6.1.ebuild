# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_6,3_7,3_8} )
inherit distutils-r1

DESCRIPTION="Create standalone executables from Python scripts"
HOMEPAGE="https://anthony-tuininga.github.io/cx_Freeze/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PYTHON"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=(
	"${FILESDIR}/${PN}-5.0.2-buildsystem.patch" # bug #491602
)
# test folder missing half the source content.
