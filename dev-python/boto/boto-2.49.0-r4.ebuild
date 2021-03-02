# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Amazon Web Services API"
HOMEPAGE="https://github.com/boto/boto https://pypi.org/project/boto/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

PATCHES=(
	# taken from https://bugs.debian.org/909545
	"${FILESDIR}"/${P}-try-to-add-SNI-support-v3.patch
	"${FILESDIR}"/${P}-py38.patch
	"${FILESDIR}"/${P}-py3-socket-binary.patch
	"${FILESDIR}"/${P}-py3-httplib-strict.patch
	"${FILESDIR}"/${P}-py3-server-port.patch
	"${FILESDIR}"/${P}-unbundle-six.patch
)

RDEPEND=">=dev-python/six-1.12.0[${PYTHON_USEDEP}]"

BDEPEND="
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
	: > "${HOME}"/.ssh/known_hosts || die

	distutils-r1_src_prepare
}

python_test() {
	nosetests -v tests/unit ||
		die "Tests fail with ${EPYTHON}"
}
