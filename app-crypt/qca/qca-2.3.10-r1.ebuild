# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake kde.org out-of-source-utils qmake-utils

DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="https://userbase.kde.org/QCA"
SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="amd64 ~arm arm64 ~loong ppc64 ~riscv ~x86"
IUSE="botan debug doc examples gcrypt gpg logger nss pkcs11 sasl softstore +ssl test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qt5compat:6
	dev-qt/qtbase:6
	botan? ( dev-libs/botan:3= )
	gcrypt? ( dev-libs/libgcrypt:= )
	gpg? ( app-crypt/gnupg )
	nss? ( dev-libs/nss )
	pkcs11? (
		>=dev-libs/openssl-1.1
		dev-libs/pkcs11-helper
	)
	sasl? ( dev-libs/cyrus-sasl:2 )
	ssl? ( >=dev-libs/openssl-1.1:= )
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qtbase:6[network] )
"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/doxygen[dot]
		virtual/latex-base
	)
"

PATCHES=( "${FILESDIR}/${PN}-disable-pgp-test.patch" )

qca_plugin_use() {
	echo -DWITH_${2:-$1}_PLUGIN=$(usex "$1")
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_WITH_QT6=ON
		-DQCA_FEATURE_INSTALL_DIR="${EPREFIX}$(qt6_get_mkspecsdir)/features"
		-DQCA_PLUGINS_INSTALL_DIR="${EPREFIX}$(qt6_get_plugindir)"
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
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_build doc
}

src_test() {
	local -x QCA_PLUGIN_PATH="${BUILD_DIR}/lib/qca"
	cmake_src_test
}

src_install() {
	cmake_src_install

	if use doc; then
		run_in_build_dir dodoc -r apidocs/html
	fi

	if use examples; then
		dodoc -r "${S}"/examples
	fi
}
