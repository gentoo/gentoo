# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils qmake-utils

DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="https://userbase.kde.org/QCA"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"

IUSE="botan debug doc examples gcrypt gpg libressl logger nss pkcs11 sasl softstore +ssl test"

COMMON_DEPEND="
	dev-qt/qtcore:5
	botan? ( dev-libs/botan:0 )
	gcrypt? ( dev-libs/libgcrypt:= )
	gpg? ( app-crypt/gnupg )
	nss? ( dev-libs/nss )
	pkcs11? (
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
		dev-libs/pkcs11-helper
	)
	sasl? ( dev-libs/cyrus-sasl:2 )
	ssl? (
		!libressl? ( >=dev-libs/openssl-1.0.1:0= )
		libressl? ( dev-libs/libressl:= )
	)
"
DEPEND="${COMMON_DEPEND}
	dev-qt/qtnetwork:5
	doc? ( app-doc/doxygen )
	test? ( dev-qt/qttest:5 )
"
RDEPEND="${COMMON_DEPEND}
	!app-crypt/qca-cyrus-sasl
	!app-crypt/qca-gnupg
	!app-crypt/qca-logger
	!app-crypt/qca-ossl
	!app-crypt/qca-pkcs11
"

PATCHES=(
	"${FILESDIR}/${PN}-disable-pgp-test.patch"
	"${FILESDIR}/${P}-c++11.patch"
)

qca_plugin_use() {
	echo -DWITH_${2:-$1}_PLUGIN=$(usex "$1")
}

src_configure() {
	local mycmakeargs=(
		-DQCA_FEATURE_INSTALL_DIR="${EPREFIX}$(qt5_get_mkspecsdir)/features"
		-DQCA_PLUGINS_INSTALL_DIR="${EPREFIX}$(qt5_get_plugindir)"
		$(qca_plugin_use botan)
		$(qca_plugin_use gcrypt)
		$(qca_plugin_use gpg gnupg)
		$(qca_plugin_use logger)
		$(qca_plugin_use nss)
		$(qca_plugin_use pkcs11)
		$(qca_plugin_use sasl cyrus-sasl)
		$(qca_plugin_use softstore)
		$(qca_plugin_use ssl ossl)
		-DBUILD_TESTS=$(usex test)
	)
	cmake-utils_src_configure
}

src_test() {
	local -x QCA_PLUGIN_PATH="${BUILD_DIR}/lib/qca"
	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install

	if use doc; then
		pushd "${BUILD_DIR}" >/dev/null || die
		doxygen Doxyfile || die
		dodoc -r apidocs/html
		popd >/dev/null || die
	fi

	if use examples; then
		dodoc -r "${S}"/examples
	fi
}
