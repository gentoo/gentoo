# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils multibuild qmake-utils

DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="http://delta.affinix.com/qca/"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"

IUSE="botan debug doc examples gcrypt gpg libressl logger nss +openssl pkcs11 +qt4 qt5 sasl softstore test"
REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	!app-crypt/qca-cyrus-sasl
	!app-crypt/qca-gnupg
	!app-crypt/qca-logger
	!app-crypt/qca-ossl
	!app-crypt/qca-pkcs11
	botan? ( dev-libs/botan )
	gcrypt? ( dev-libs/libgcrypt:= )
	gpg? ( app-crypt/gnupg )
	nss? ( dev-libs/nss )
	openssl? (
		!libressl? ( >=dev-libs/openssl-1.0.1:0 )
		libressl? ( dev-libs/libressl )
	)
	pkcs11? (
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
		dev-libs/pkcs11-helper
	)
	qt4? ( dev-qt/qtcore:4 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtconcurrent:5
		dev-qt/qtnetwork:5
	)
	sasl? ( dev-libs/cyrus-sasl:2 )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? (
		qt4? ( dev-qt/qttest:4 )
		qt5? ( dev-qt/qttest:5 )
	)
"

DOCS=( README TODO )

PATCHES=(
	"${FILESDIR}/${PN}-disable-pgp-test.patch"
)

qca_plugin_use() {
	echo -DWITH_${2:-$1}_PLUGIN=$(usex "$1")
}

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
}

src_configure() {
	myconfigure() {
		local mycmakeargs=(
			-DQCA_FEATURE_INSTALL_DIR="${EPREFIX}$(${MULTIBUILD_VARIANT}_get_mkspecsdir)/features"
			-DQCA_PLUGINS_INSTALL_DIR="${EPREFIX}$(${MULTIBUILD_VARIANT}_get_plugindir)"
			$(qca_plugin_use botan)
			$(qca_plugin_use gcrypt)
			$(qca_plugin_use gpg gnupg)
			$(qca_plugin_use logger)
			$(qca_plugin_use nss)
			$(qca_plugin_use openssl ossl)
			$(qca_plugin_use pkcs11)
			$(qca_plugin_use sasl cyrus-sasl)
			$(qca_plugin_use softstore)
			$(cmake-utils_use_build test TESTS)
		)

		if [[ ${MULTIBUILD_VARIANT} == qt4 ]]; then
			mycmakeargs+=(-DQT4_BUILD=ON)
		fi

		cmake-utils_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile
}

src_test() {
	mytest() {
		local -x QCA_PLUGIN_PATH="${BUILD_DIR}/lib/qca"
		cmake-utils_src_test
	}

	multibuild_foreach_variant mytest
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install

	if use doc; then
		pushd "${BUILD_DIR}" >/dev/null || die
		doxygen Doxyfile.in || die
		dodoc -r apidocs/html
		popd >/dev/null || die
	fi

	if use examples; then
		dodoc -r "${S}"/examples
	fi
}
