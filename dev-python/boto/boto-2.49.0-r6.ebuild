# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Amazon Web Services API"
HOMEPAGE="https://github.com/boto/boto https://pypi.org/project/boto/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ~ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

PATCHES=(
	# taken from https://bugs.debian.org/909545
	"${FILESDIR}"/${P}-try-to-add-SNI-support-v3.patch
	"${FILESDIR}"/${P}-py38.patch
	"${FILESDIR}"/${P}-py3-socket-binary.patch
	"${FILESDIR}"/${P}-py3-httplib-strict.patch
	"${FILESDIR}"/${P}-py3-server-port.patch
	"${FILESDIR}"/${P}-unbundle-six.patch
	"${FILESDIR}"/${P}-py310.patch
	"${FILESDIR}"/${P}-mock-spec.patch
)

RDEPEND="
	>=dev-python/six-1.12.0[${PYTHON_USEDEP}]
"

BDEPEND="
	${RDEPEND}
	test? (
		dev-python/httpretty[${PYTHON_USEDEP}]
		dev-python/keyring[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/paramiko[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/rsa[${PYTHON_USEDEP}]
		dev-python/selenium[${PYTHON_USEDEP}]
	)"

distutils_enable_tests nose

src_prepare() {
	# remove bundled libs.
	rm -f "${S}"/boto/vendored/six.py || die
	# broken, not worth fixing
	rm tests/unit/cloudfront/test_signed_urls.py || die
	# fix tests
	mkdir -p "${HOME}"/.ssh || die
	touch "${HOME}"/.ssh/known_hosts || die

	distutils-r1_src_prepare
}

python_test() {
	distutils-r1_python_test tests/unit
}
