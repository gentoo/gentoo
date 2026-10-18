# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 eapi9-ver

MY_PV=$(ver_rs 3 -)
MY_P="cloudflare-python-${MY_PV}"
DESCRIPTION="The official Python library for the Cloudflare API"
HOMEPAGE="
	https://github.com/cloudflare/cloudflare-python
	https://pypi.org/project/cloudflare/
"
SRC_URI="
	https://github.com/cloudflare/cloudflare-python/archive/refs/tags/v${MY_PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64"
PROPERTIES="test? ( test_network )"

# Note for maintainers: watch follow issue to switch for httpx2
# https://github.com/cloudflare/cloudflare-python/issues/2733
RDEPEND="
	>=dev-python/anyio-3.5.0[${PYTHON_USEDEP}]
	<dev-python/anyio-5[${PYTHON_USEDEP}]
	>=dev-python/distro-1.7.0[${PYTHON_USEDEP}]
	<dev-python/distro-2[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.23.0[${PYTHON_USEDEP}]
	<dev-python/httpx-1[${PYTHON_USEDEP}]
	>=dev-python/pydantic-1.9.0[${PYTHON_USEDEP}]
	<dev-python/pydantic-3[${PYTHON_USEDEP}]
	dev-python/sniffio[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.14[${PYTHON_USEDEP}]
	<dev-python/typing-extensions-5[${PYTHON_USEDEP}]
"

# tests/api_resources needs the prism mock server (@stainless-api/prism-cli),
# an npm package that is not in the tree. Everything else is either pure unit
# tests or mocked with respx.
BDEPEND+="
	test? (
		>=dev-python/dirty-equals-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/httpx-aiohttp-0.1.9[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-asyncio respx )
distutils_enable_tests pytest

EPYTEST_IGNORE=( tests/api_resources )
# The generated tests expect a CLOUDFLARE_API_VERSION environment variable and
# api_version format validation that the generated client does not implement.
# https://github.com/cloudflare/cloudflare-python/issues/2745
EPYTEST_DESELECT=(
	tests/test_client.py::TestAsyncCloudflare::test_api_version_env_var
	tests/test_client.py::TestAsyncCloudflare::test_api_version_omitted_when_empty
	tests/test_client.py::TestAsyncCloudflare::test_api_version_rejects_invalid_format
	tests/test_client.py::TestCloudflare::test_api_version_env_var
	tests/test_client.py::TestCloudflare::test_api_version_omitted_when_empty
	tests/test_client.py::TestCloudflare::test_api_version_rejects_invalid_format
)

src_prepare() {
	distutils-r1_src_prepare

	# Drop -n auto, pytest-xdist is not worth pulling in for a 10 s suite
	sed -i -e '/^addopts = /d' pyproject.toml || die
}
