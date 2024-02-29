# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="readline(+),ssl(+)"

if [[ ${PV} = "9999" ]]; then
	EGIT_REPO_URI="https://github.com/williamh/pybugz.git"
	inherit git-r3
else
	SRC_URI="https://github.com/williamh/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
fi

inherit distutils-r1

DESCRIPTION="Command line interface to (Gentoo) Bugzilla"
HOMEPAGE="https://github.com/williamh/pybugz"

LICENSE="GPL-2"
SLOT="0"
RESTRICT="test"
PROPERTIES="test_network"

python_test() {
	# not the highest quality of test, but checks many parts of the code work.
	# good enough for PYTHON_COMPAT checks.
	"${EPYTHON}" lbugz get 784263 || die "Tests failed with ${EPYTHON}"
}
