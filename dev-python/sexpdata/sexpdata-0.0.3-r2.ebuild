# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="a simple S-expression parser/serializer"
HOMEPAGE="https://github.com/jd-boyd/sexpdata"
SRC_URI="https://github.com/jd-boyd/sexpdata/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"

distutils_enable_tests nose
