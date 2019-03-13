# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# WARNING! Don't switch to EAPI-6 without checking paths of installed files
# carefully. The .so file might get installed into /
EAPI=5
inherit autotools apache-module

DESCRIPTION="mod_gnutls uses GnuTLS for SSL/TLS encryption in Apache2 (compare to mod_ssl)"
HOMEPAGE="https://mod.gnutls.org/"
SRC_URI="https://mod.gnutls.org/downloads/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND=">=net-libs/gnutls-3.3.0:="
DEPEND="${CDEPEND}
	test? ( app-crypt/monkeysphere )"
RDEPEND="${CDEPEND}"

# Fails because gpg-agent cannot be accessed
RESTRICT="test"

APACHE2_MOD_CONF="47_${PN}"
APACHE2_MOD_DEFINE="GNUTLS"

DOCFILES="CHANGELOG NOTICE README"

need_apache2_4

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
