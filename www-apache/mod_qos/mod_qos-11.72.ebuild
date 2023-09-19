# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools apache-module

DESCRIPTION="A QOS module for the apache webserver"
HOMEPAGE="http://mod-qos.sourceforge.net/"
SRC_URI="mirror://sourceforge/mod-qos/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-libs/libpcre:3
	dev-libs/openssl:0=
	media-libs/libpng:0=
	sys-libs/zlib:0=
"
DEPEND="${RDEPEND}"

APXS2_S="${S}/apache2"
APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="QOS"
DOCFILES="${S}/doc/*.txt ${S}/README.TXT"

need_apache2

pkg_setup() {
	_init_apache2
	_init_apache2_late
}
src_prepare() {
	default

	pushd "${S}"/tools &>/dev/null || die
	eautoreconf
	popd &>/dev/null || die
}

src_configure() {
	pushd "${S}"/tools &>/dev/null || die
	econf
	popd &>/dev/null || die
}

src_compile() {
	apache-module_src_compile
	emake -C "${S}"/tools
}

src_install() {
	einfo "Installing Apache module ..."
	pushd "${S}"/tools &>/dev/null || die
	apache-module_src_install
	popd &>/dev/null || die

	einfo "Installing module utilities ..."
	emake -C "${S}"/tools install DESTDIR="${D}"
}
