# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517="hatchling"
inherit distutils-r1

# check .stats.yml openapi_spec_url
# TODO: Mapping with https://github.com/cloudflare/api-schemas commits?
CLOUDFLARE_API_HASH="3d78f855257b55bbb80884f99c3802cae877968d140eed3557fcb2cdd5f937b3"
PRISM_VER="5.12.0"

DESCRIPTION="Python wrapper for the Cloudflare v4 API"
HOMEPAGE="https://developers.cloudflare.com/api/"
SRC_URI="https://github.com/cloudflare/cloudflare-python/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz
	test? (
		https://storage.googleapis.com/stainless-sdk-openapi-specs/cloudflare%2Fcloudflare-${CLOUDFLARE_API_HASH}.yml ->
			cloudflare-${CLOUDFLARE_API_HASH}.yml
		https://registry.npmjs.org/@stoplight/prism-cli/-/prism-cli-${PRISM_VER}.tgz
		https://github.com/winterheart/prism/releases/download/v5.12.0/@stoplight-prism-cli-${PRISM_VER}-node_modules.tgz
	)"
S="${WORKDIR}/${PN}-python-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="${DEPEND}
	>=dev-python/httpx-0.23.0[${PYTHON_USEDEP}]
	>=dev-python/pydantic-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.10[${PYTHON_USEDEP}]
	>=dev-python/anyio-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/distro-1.7.0[${PYTHON_USEDEP}]
	dev-python/sniffio[${PYTHON_USEDEP}]
"

BDEPEND="test? (
	>=net-libs/nodejs-18.20.1
	dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	dev-python/time-machine[${PYTHON_USEDEP}]
	dev-python/dirty-equals[${PYTHON_USEDEP}]
	dev-python/respx[${PYTHON_USEDEP}]
)"

EPYTEST_DESELECT=(
	# Fails in sandbox environment
	tests/test_client.py::TestAsyncCloudflare::test_copy_build_request
	tests/test_client.py::TestCloudflare::test_copy_build_request
)

distutils_enable_tests pytest

src_test() {
	start_mock
	distutils-r1_src_test
	stop_mock
}

start_mock() {
	# Run prism mock api server, this is what needs nodejs
	node --no-warnings "${WORKDIR}/package/dist/index.js" mock \
		"${DISTDIR}/cloudflare-${CLOUDFLARE_API_HASH}.yml" > prism.log \
		|| die "Failed starting prism" &
	echo $! >"${T}/mock.pid" || die
	# Wait for server to come online
	echo -n "Waiting for mockserver"
	while ! grep -q "✖  fatal\|Prism is listening" "prism.log" ; do
	    echo -n "." || die
	    sleep 0.5
	done
	if grep -q "✖  fatal" prism.log; then
		die "Prism mock server failed"
	fi
}

stop_mock() {
	kill $(cat "${T}/mock.pid") || die
}
