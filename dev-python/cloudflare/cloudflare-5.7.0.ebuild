# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 eapi9-ver

DESCRIPTION="The official Python library for the Cloudflare API"
HOMEPAGE="
	https://github.com/cloudflare/cloudflare-python
	https://pypi.org/project/cloudflare/
"

MYPN="cloudflare-python"
MYPV=$(ver_rs 3 -)
SRC_URI="
	https://github.com/cloudflare/cloudflare-python/archive/refs/tags/v${MYPV}.tar.gz
		-> ${MYPN}-${MYPV}.gh.tar.gz
"
S="${WORKDIR}/${MYPN}-${MYPV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/anyio-3.5.0[${PYTHON_USEDEP}]
	<dev-python/anyio-5[${PYTHON_USEDEP}]
	>=dev-python/distro-1.7.0[${PYTHON_USEDEP}]
	<dev-python/distro-2[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.23.0[${PYTHON_USEDEP}]
	<dev-python/httpx-1[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.12[${PYTHON_USEDEP}]
	<dev-python/pydantic-3[${PYTHON_USEDEP}]
	dev-python/sniffio[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.14[${PYTHON_USEDEP}]
	<dev-python/typing-extensions-5[${PYTHON_USEDEP}]
"

# tests/api_resources needs the prism mock server (@stainless-api/prism-cli),
# an npm package that is not in the tree. Everything else is either pure unit
# tests or mocked with respx.
BDEPEND="
	test? (
		dev-python/dirty-equals[${PYTHON_USEDEP}]
		dev-python/httpx-aiohttp[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-asyncio respx )
EPYTEST_IGNORE=( tests/api_resources )
# The generated tests expect a CLOUDFLARE_API_VERSION environment variable and
# api_version format validation that the generated client does not implement.
# https://github.com/cloudflare/cloudflare-python/issues/2745
EPYTEST_DESELECT=(
	tests/test_client.py::TestCloudflare::test_api_version_env_var
	tests/test_client.py::TestCloudflare::test_api_version_omitted_when_empty
	tests/test_client.py::TestCloudflare::test_api_version_rejects_invalid_format
	tests/test_client.py::TestAsyncCloudflare::test_api_version_env_var
	tests/test_client.py::TestAsyncCloudflare::test_api_version_omitted_when_empty
	tests/test_client.py::TestAsyncCloudflare::test_api_version_rejects_invalid_format
)
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# Drop -n auto, pytest-xdist is not worth pulling in for a 10 s suite
	sed -i -e '/^addopts = /d' pyproject.toml || die
}

DOCS=(
	"docs/migration-guides/v5.0.0-migration-guide.md"
)

pkg_postinst() {
	if ver_replacing -lt "5.0.0_beta1"; then
		elog "Cloudflare 5 has several breaking changes"
		elog "See /usr/share/doc/${P}/docs/v5-migration-guide.md"
		elog "It also includes a new optional dependency on httpx-aiohttp"
		elog "Check the README for details"
	fi
}
