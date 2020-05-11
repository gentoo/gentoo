# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# The selftests fail with pypy, and urlgrabber segfaults for me.
PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1 toolchain-funcs

DESCRIPTION="python binding for curl/libcurl"
HOMEPAGE="
	https://github.com/pycurl/pycurl
	https://pypi.org/project/pycurl/
	http://pycurl.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="curl_ssl_gnutls curl_ssl_libressl curl_ssl_nss +curl_ssl_openssl examples ssl test"
RESTRICT="!test? ( test )"

# Depend on a curl with curl_ssl_* USE flags.
# libcurl must not be using an ssl backend we do not support.
# If the libcurl ssl backend changes pycurl should be recompiled.
# If curl uses gnutls, depend on at least gnutls 2.11.0 so that pycurl
# does not need to initialize gcrypt threading and we do not need to
# explicitly link to libgcrypt.
RDEPEND="
	>=net-misc/curl-7.25.0-r1:=[ssl=]
	ssl? (
		net-misc/curl[curl_ssl_gnutls(-)=,curl_ssl_libressl(-)=,curl_ssl_nss(-)=,curl_ssl_openssl(-)=,-curl_ssl_axtls(-),-curl_ssl_cyassl(-)]
		curl_ssl_gnutls? ( >=net-libs/gnutls-2.11.0:= )
		curl_ssl_libressl? ( dev-libs/libressl:= )
		curl_ssl_openssl? ( dev-libs/openssl:= )
	)"

# bottle-0.12.7: https://github.com/pycurl/pycurl/issues/180
# bottle-0.12.7: https://github.com/defnull/bottle/commit/f35197e2a18de1672831a70a163fcfd38327a802
DEPEND="${RDEPEND}
	test? (
		dev-python/bottle[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		net-misc/curl[curl_ssl_gnutls(-)=,curl_ssl_libressl(-)=,curl_ssl_nss(-)=,curl_ssl_openssl(-)=,-curl_ssl_axtls(-),-curl_ssl_cyassl(-),http2]
		>=dev-python/bottle-0.12.7[${PYTHON_USEDEP}]
	)"
# Needed for individual runs of testsuite by python impls.
DISTUTILS_IN_SOURCE_BUILD=1

PATCHES=(
	"${FILESDIR}"/pycurl-7.43.0.5-telnet-test.patch
	"${FILESDIR}"/pycurl-7.43.0.5-cc-cflags.patch
)

python_prepare_all() {
	sed -e "/setup_args\['data_files'\] = /d" -i setup.py || die
	distutils-r1_python_prepare_all
}

python_configure_all() {
	# Override faulty detection in setup.py, bug 510974.
	export PYCURL_SSL_LIBRARY=${CURL_SSL/libressl/openssl}
}

src_test() {
	# upstream bundles precompiled amd64 libs
	rm tests/fake-curl/libcurl/*.so || die
	emake -C tests/fake-curl/libcurl CC="$(tc-getCC)"

	distutils-r1_src_test
}

python_compile() {
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_test() {
	nosetests -a '!standalone,!gssapi' -v --with-flaky || die "Tests fail with ${EPYTHON}"
	nosetests -a 'standalone' -v --with-flaky || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	local HTML_DOCS=( doc/. )
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
