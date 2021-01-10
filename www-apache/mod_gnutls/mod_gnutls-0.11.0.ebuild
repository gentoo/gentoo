# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# WARNING! Don't switch to EAPI-6 without checking paths of installed files
# carefully. The .so file might get installed into /
EAPI=6

PYTHON_COMPAT=( python3_{6..9} )

inherit autotools apache-module python-any-r1

DESCRIPTION="mod_gnutls uses GnuTLS for SSL/TLS encryption in Apache2 (compare to mod_ssl)"
HOMEPAGE="https://mod.gnutls.org/"
SRC_URI="https://mod.gnutls.org/downloads/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND=">=net-libs/gnutls-3.3.0:=[pkcs11]"

TEST_REQUIRED_APACHE_MODULES="apache2_modules_proxy,apache2_modules_proxy_http"

DEPEND="${CDEPEND}
	virtual/pkgconfig
	$(python_gen_any_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
	test? (
		app-crypt/monkeysphere
		>=net-libs/gnutls-3.3.0:=[tools]
		net-misc/curl
		|| (
			www-servers/apache[apache2_mpms_worker,${TEST_REQUIRED_APACHE_MODULES}]
			www-servers/apache[apache2_mpms_prefork,${TEST_REQUIRED_APACHE_MODULES}]
			www-servers/apache[apache2_mpms_event,${TEST_REQUIRED_APACHE_MODULES}]
		)
	)"

RDEPEND="${CDEPEND}"

RESTRICT="!test? ( test )"

APACHE2_MOD_CONF="47_${PN}"
APACHE2_MOD_DEFINE="GNUTLS"

DOCFILES="CHANGELOG NOTICE README"

need_apache2_4

python_check_deps() {
	has_version "dev-python/pyyaml[${PYTHON_USEDEP}]"
}

pkg_setup() {
	# Calling depend.apache_pkg_setup fails because we do not have
	# "apache2" in IUSE but the function expects this in order to call
	# _init_apache2_late which sets the APACHE_MODULESDIR variable.
	_init_apache2
	_init_apache2_late

	python-any-r1_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-apxs="${APXS}"
		--disable-strict
		--disable-doxygen-dot
		--disable-doxygen-doc
		--disable-doxygen-html
		--disable-doxygen-pdf
		--disable-valgrind-test
		ac_cv_path_UNSHARE=no
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake
}

src_install() {
	apache-module_src_install
}
