# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} python3_{14,15}t )
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="fast JSON in Python"
HOMEPAGE="
	https://pypi.org/project/fastsimdjson/
	https://github.com/simdjson/fastpysimdjson
"

SIMDJSON_DATA_HASH="351949906abde446f0314bf79606fb5d884f5be7"
SRC_URI+="
	test? (
		https://github.com/simdjson/simdjson-data/archive/${SIMDJSON_DATA_HASH}.tar.gz
			-> simdjson-data-${SIMDJSON_DATA_HASH}.tar.gz
	)
"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-libs/simdjson-5.0.2:=[nan]
	>=dev-cpp/simdutf-9.2:=
	dev-libs/zmij:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/wheel[${PYTHON_USEDEP}]
"
# there is an optional test dep on dev-python/orjson, left that out since it's marked as deprecated

PATCHES=(
	"${FILESDIR}/fastsimdjson-0.8.0-unbundle.patch"
)

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_prepare_all() {
	# remove bundled deps
	rm -rf vendor || die

	distutils-r1_python_prepare_all
}

python_test() {
	ln -sfn "${WORKDIR}/simdjson-data-${SIMDJSON_DATA_HASH}" "simdjson-data" || die

	distutils-r1_python_test
}
