# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/floyernick/fleep-py.git"
	inherit git-r3
else
	# upstream aren't tagging the releases, just as commit title
	COMMIT="994bc2c274482d80ab13d89d8f7343eb316d3e44"
	SRC_URI="https://github.com/floyernick/fleep-py/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/fleep-py-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="File format determination library for Python"
HOMEPAGE="https://github.com/floyernick/fleep-py"

LICENSE="MIT"
SLOT="0"

python_test() {
	cd tests || die
	"${EPYTHON}" maintest.py || die "Tests fail with ${EPYTHON}"
}
