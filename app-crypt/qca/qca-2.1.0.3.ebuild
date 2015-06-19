# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/qca/qca-2.1.0.3.ebuild,v 1.7 2015/04/02 14:06:37 kensington Exp $

EAPI=5

MY_PN="${PN}-qt5"
inherit multilib cmake-utils multibuild

DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="http://delta.affinix.com/qca/"
SRC_URI="mirror://kde/stable/${MY_PN}/${PV}/src/${MY_PN}-${PV}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"

IUSE="botan debug doc examples gcrypt gpg logger nss +openssl pkcs11 +qt4 qt5 sasl softstore test"
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
	openssl? ( dev-libs/openssl:0 )
	pkcs11? (
		dev-libs/openssl:0
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

S=${WORKDIR}/${MY_PN}-${PV}

PATCHES=(
	"${FILESDIR}/${PN}-disable-pgp-test.patch"
	"${FILESDIR}/${P}-qt55.patch"
)

qca_plugin_use() {
	echo "-DWITH_${2:-$1}_PLUGIN=$(use $1 && echo yes || echo no)"
}

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
}

src_configure() {
	myconfigure() {
		local mycmakeargs=(
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

		if [[ ${MULTIBUILD_VARIANT} = qt4 ]]; then
			mycmakeargs+=(
				-DQT4_BUILD=ON
				-DQCA_PLUGINS_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)/qt4/plugins"
				-DQCA_FEATURE_INSTALL_DIR="${EPREFIX}/usr/share/qt4/mkspecs/features"
			)
		fi

		if [[ ${MULTIBUILD_VARIANT} = qt5 ]]; then
			mycmakeargs+=(
				-DQCA_PLUGINS_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)/qt5/plugins"
				-DQCA_FEATURE_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)/qt5/mkspecs/features"
			)
		fi

		cmake-utils_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install

	if use doc; then
		pushd "${BUILD_DIR}" >/dev/null
		doxygen Doxyfile.in || die
		dohtml apidocs/html/*
		popd >/dev/null
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r "${S}"/examples
	fi

	cmake-utils_src_install
}

src_test() {
	multibuild_foreach_variant cmake-utils_src_test
}
