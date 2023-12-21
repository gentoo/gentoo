# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake kde.org multibuild out-of-source-utils qmake-utils

DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="https://userbase.kde.org/QCA"
SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="amd64 ~arm arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="botan debug doc examples gcrypt gpg logger nss pkcs11 +qt5 qt6 sasl softstore +ssl test"
REQUIRED_USE="|| ( qt5 qt6 )"

RESTRICT="!test? ( test )"

RDEPEND="
	botan? ( dev-libs/botan:3= )
	gcrypt? ( dev-libs/libgcrypt:= )
	gpg? ( app-crypt/gnupg )
	nss? ( dev-libs/nss )
	pkcs11? (
		>=dev-libs/openssl-1.1
		dev-libs/pkcs11-helper
	)
	qt5? ( >=dev-qt/qtcore-5.14:5 )
	qt6? (
		dev-qt/qtbase:6
		dev-qt/qt5compat:6
	)
	sasl? ( dev-libs/cyrus-sasl:2 )
	ssl? ( >=dev-libs/openssl-1.1:= )
"
DEPEND="${RDEPEND}
	test? (
		qt5? (
			dev-qt/qtnetwork:5
			dev-qt/qttest:5
		)
		qt6? ( dev-qt/qtbase:6[network] )
	)
"
BDEPEND="
	doc? (
		app-doc/doxygen[dot]
		virtual/latex-base
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-disable-pgp-test.patch"
	"${FILESDIR}/${P}-use-sha256-not-sha1.patch" # git master
)

qca_plugin_use() {
	echo -DWITH_${2:-$1}_PLUGIN=$(usex "$1")
}

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt5) $(usev qt6) )
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
			$(qca_plugin_use pkcs11)
			$(qca_plugin_use sasl cyrus-sasl)
			$(qca_plugin_use softstore)
			$(qca_plugin_use ssl ossl)
			-DBUILD_TESTS=$(usex test)
		)
		if [[ ${MULTIBUILD_VARIANT} == qt6 ]]; then
				mycmakeargs+=( -DBUILD_WITH_QT6=ON )
		else
				mycmakeargs+=( -DBUILD_WITH_QT6=OFF )
		fi
		cmake_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
	if use doc; then
		multibuild_for_best_variant cmake_build doc
	fi
}

src_test() {
	mytest() {
		local -x QCA_PLUGIN_PATH="${BUILD_DIR}/lib/qca"
		cmake_src_test
	}
	multibuild_foreach_variant mytest
}

src_install() {
	multibuild_foreach_variant cmake_src_install

	if use doc; then
		multibuild_for_best_variant run_in_build_dir dodoc -r apidocs/html
	fi

	if use examples; then
		dodoc -r "${S}"/examples
	fi
}
