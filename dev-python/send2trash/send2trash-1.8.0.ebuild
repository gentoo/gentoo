# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Sends files to the Trash (or Recycle Bin)"
HOMEPAGE="
	https://pypi.org/project/Send2Trash/
	https://github.com/arsenetar/send2trash/"
SRC_URI="
	https://github.com/arsenetar/send2trash/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"

distutils_enable_tests pytest
