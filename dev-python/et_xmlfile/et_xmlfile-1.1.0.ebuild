# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_PV=${PV%.0}
MY_P=${PN}-${MY_PV}

DESCRIPTION="An implementation of lxml.xmlfile for the standard library"
HOMEPAGE="
	https://pypi.org/project/et-xmlfile/
	https://foss.heptapod.net/openpyxl/et_xmlfile/"
SRC_URI="
	https://foss.heptapod.net/openpyxl/et_xmlfile/-/archive/${MY_PV}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-python/lxml[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
distutils_enable_sphinx doc
