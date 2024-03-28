# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..12} )

OPENTELEMETRY_PUBLIC="1.23.0"
OPENTELEMETRY_PRIVATE="0.44_beta0"

inherit distutils-r1

DESCRIPTION="OpenTelemetry Python SDK"
HOMEPAGE="
	https://opentelemetry.io/
	https://pypi.org/project/opentelemetry-sdk/
	https://github.com/open-telemetry/opentelemetry-python/
"
SRC_URI="
	https://github.com/open-telemetry/opentelemetry-python/archive/refs/tags/v${OPENTELEMETRY_PUBLIC}.tar.gz
		-> opentelemetry-python-${OPENTELEMETRY_PUBLIC}.gh.tar.gz
"

S="${WORKDIR}/opentelemetry-python-${OPENTELEMETRY_PUBLIC}/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	~dev-python/opentelemetry-api-${OPENTELEMETRY_PUBLIC}[${PYTHON_USEDEP}]
	~dev-python/opentelemetry-semantic-conventions-${OPENTELEMETRY_PRIVATE}[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/asgiref[${PYTHON_USEDEP}]
		dev-python/attrs[${PYTHON_USEDEP}]
		dev-python/deprecated[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/importlib-metadata[${PYTHON_USEDEP}]
		dev-python/iniconfig[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pluggy[${PYTHON_USEDEP}]
		dev-python/py-cpuinfo[${PYTHON_USEDEP}]
		dev-python/py[${PYTHON_USEDEP}]
		dev-python/tomli[${PYTHON_USEDEP}]
		dev-python/wrapt[${PYTHON_USEDEP}]
		dev-python/zipp[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	cp -a "${BUILD_DIR}"/{install,test} || die
	local -x PATH=${BUILD_DIR}/test/usr/bin:${PATH}

	for dep in tests/opentelemetry-test-utils; do
		pushd "${WORKDIR}/opentelemetry-python-${OPENTELEMETRY_PUBLIC}/${dep}" >/dev/null || die
		distutils_pep517_install "${BUILD_DIR}"/test
		popd >/dev/null || die
	done

	local -x EPYTEST_IGNORE=(
		tests/performance/benchmarks/
	)

	epytest
}
