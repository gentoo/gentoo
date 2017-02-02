# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils autotools mozextension multilib

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/Fedict/${PN}.git
		https://github.com/Fedict/${PN}.git"
	inherit git-r3
	SRC_URI=""
else
	SRC_URI="https://codeload.github.com/fedict/${PN}/tar.gz/v${PV} ->
	${P}.tar.gz"
	KEYWORDS="~x86 ~amd64 ~arm"
fi

SLOT="0"
LICENSE="LGPL-3"
DESCRIPTION="Electronic Identity Card middleware supplied by the Belgian Federal Government"

HOMEPAGE="http://eid.belgium.be"

IUSE="+dialogs +gtk p11-kit +xpi"

REQUIRED_USE="
	dialogs? ( gtk )"

RDEPEND="gtk? (
		x11-libs/gtk+:*
		dev-libs/libxml2
		net-misc/curl[ssl]
		net-libs/libproxy
		!app-misc/eid-viewer-bin
	)
	>=sys-apps/pcsc-lite-1.2.9
	p11-kit? ( app-crypt/p11-kit )
	xpi? ( || ( >=www-client/firefox-bin-3.6.24
		>=www-client/firefox-3.6.20 ) )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	eapply_user

	sed -i -e 's:/beid/rsaref220:/rsaref220:' configure.ac || die
	sed -i -e 's:/beid::' cardcomm/pkcs11/src/libbeidpkcs11.pc.in || die

	# hardcoded lsb_info
	sed -i \
		-e "s:get_lsb_info('i'):strdup(_(\"Gentoo\")):" \
		-e "s:get_lsb_info('r'):strdup(_(\"n/a\")):" \
		-e "s:get_lsb_info('c'):strdup(_(\"n/a\")):" \
		plugins_tools/aboutmw/gtk/about-main.c || die

	if [[ ${PV} == "9999" ]] ; then
		use gtk || eapply "${FILESDIR}"/gtk_not_required_9999.patch
	else
		use gtk || eapply "${FILESDIR}"/gtk_not_required_4_2.patch
	fi

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable dialogs) \
		$(use_enable p11-kit p11kit) \
		--with-gnu-ld \
		--disable-static \
		--disable-signed
}

src_install() {
	emake DESTDIR="${D}" install

	if use xpi; then
		declare MOZILLA_FIVE_HOME
		if has_version '>=www-client/firefox-3.6.20'; then
			MOZILLA_FIVE_HOME="/usr/$(get_libdir)/firefox"
			xpi_install "${D}/usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/belgiumeid@eid.belgium.be"
		fi
		if has_version '>=www-client/firefox-bin-3.6.24'; then
			MOZILLA_FIVE_HOME="/opt/firefox"
			xpi_install "${D}/usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/belgiumeid@eid.belgium.be"
		fi
	fi
	rm -r "${D}/usr/share/mozilla" "${D}"/usr/$(get_libdir)/*.la || die
	use gtk || rm -r "${D}/usr/include/eid-util" || die
}

pkg_postinst()
{
	use gtk && glib-compile-schemas /usr/share/glib-2.0/schemas/
}
