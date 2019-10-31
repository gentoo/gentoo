# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Pytest plugin to control whether tests are run that have remote data"
HOMEPAGE="https://github.com/astropy/pytest-remotedata"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

DEPEND="
	${RDEPEND}
"

python_test() {
	# Exclude operations that performs network operations
	local skipped=( "local" "internet" "default_behavior" "with_decorator" )

	local args="not ${skipped[0]}"
	for i in "${skipped[@]:1}"; do
		args+=" and not ${i}"
	done

	pytest -vv -k "${args}" tests || die "Tests failed under ${EPYTHON}"
}
