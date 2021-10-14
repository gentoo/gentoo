# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Take an SVG file and produce a cleaner and more concise file"
HOMEPAGE="https://github.com/scour-project/scour"
SRC_URI="https://github.com/scour-project/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"

python_test() {
	"${EPYTHON}" test_scour.py -v || die "Tests fail with ${EPYTHON}"
}
