# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools mozextension gnome2-utils

DESCRIPTION="Electronic Identity Card middleware supplied by the Belgian Federal Government"
HOMEPAGE="https://eid.belgium.be"
SRC_URI="https://codeload.github.com/fedict/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm"
IUSE="+dialogs +gtk p11-kit +xpi"

RDEPEND=">=sys-apps/pcsc-lite-1.2.9
	gtk? (
		x11-libs/gdk-pixbuf[jpeg]
		x11-libs/gtk+:*
		dev-libs/libxml2
		net-misc/curl[ssl]
		net-libs/libproxy
		!app-misc/eid-viewer-bin
	)
	p11-kit? ( app-crypt/p11-kit )
	xpi? ( || ( >=www-client/firefox-bin-3.6.24
		>=www-client/firefox-3.6.20 ) )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

REQUIRED_USE="dialogs? ( gtk )"

src_prepare() {
	default

	sed -i -e 's:/beid/rsaref220:/rsaref220:' configure.ac || die
	sed -i -e 's:/beid::' cardcomm/pkcs11/src/libbeidpkcs11.pc.in || die

	# hardcoded lsb_info
	sed -i \
		-e "s:get_lsb_info('i'):strdup(_(\"Gentoo\")):" \
		-e "s:get_lsb_info('r'):strdup(_(\"n/a\")):" \
		-e "s:get_lsb_info('c'):strdup(_(\"n/a\")):" \
		plugins_tools/aboutmw/gtk/about-main.c || die

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable dialogs) \
		$(use_enable p11-kit p11kit) \
		$(use_with gtk gtkvers 'detect') \
		--with-gnu-ld \
		--disable-static \
		--disable-signed
}

src_install() {
	default

	if use xpi; then
		declare MOZILLA_FIVE_HOME
		if has_version '>=www-client/firefox-3.6.20'; then
			MOZILLA_FIVE_HOME="/usr/$(get_libdir)/firefox"
			xpi_install "${ED}/usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/belgiumeid@eid.belgium.be"
		fi
		if has_version '>=www-client/firefox-bin-3.6.24'; then
			MOZILLA_FIVE_HOME="/opt/firefox"
			xpi_install "${ED}/usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/belgiumeid@eid.belgium.be"
		fi
	else
		rm -r "${ED}"/usr/lib/mozilla || die
	fi
	rm -r "${ED}/usr/share/mozilla" "${ED}"/usr/$(get_libdir)/*.la || die

	if use gtk; then
		rm -r "${ED}/usr/include/eid-util" || die
	fi
}

pkg_postinst(){
	if use gtk; then
		gnome2_schemas_update
		gnome2_icon_cache_update
	fi
}

pkg_postrm(){
	if use gtk; then
		gnome2_schemas_update
		gnome2_icon_cache_update
	fi
}
