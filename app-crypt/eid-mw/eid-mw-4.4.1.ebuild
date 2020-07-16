# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools gnome2-utils

DESCRIPTION="Electronic Identity Card middleware supplied by the Belgian Federal Government"
HOMEPAGE="https://eid.belgium.be"
SRC_URI="https://codeload.github.com/fedict/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+dialogs +gtk p11-kit"

RDEPEND=">=sys-apps/pcsc-lite-1.2.9
	gtk? (
		x11-libs/gdk-pixbuf[jpeg]
		x11-libs/gtk+:*
		dev-libs/libxml2
		net-misc/curl[ssl]
		net-libs/libproxy
		!app-misc/eid-viewer-bin
	)
	p11-kit? ( app-crypt/p11-kit )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

REQUIRED_USE="dialogs? ( gtk )"

src_prepare() {
	default

	sed -i -e 's:/beid/rsaref220:/rsaref220:' configure.ac || die
	sed -i -e 's:/beid::' cardcomm/pkcs11/src/libbeidpkcs11.pc.in || die

	# Buggy internal versioning when autoreconf a tarball release.
	# Weird numbering is required otherwise we get a seg fault in
	# about-eid-mw program.
	echo "${PV}-v${PV}" > .version
	sed -i \
		-e '/^GITDESC/ d' \
		-e '/^VERCLEAN/ d' \
		scripts/build-aux/genver.sh

	# legacy xpi module : we don't want it anymore
	sed -i -e 's:plugins_tools/xpi$::' Makefile.am || die
	sed -i -e '/plugins_tools\/xpi/ d' configure.ac || die

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
		--disable-static
}

src_install() {
	default
	rm -r "${ED}"/usr/$(get_libdir)/*.la || die
	if use gtk; then
		domenu plugins_tools/eid-viewer/eid-viewer.desktop
		doicon plugins_tools/eid-viewer/gtk/eid-viewer.png
	fi
}

pkg_postinst() {
	if use gtk; then
		gnome2_schemas_update
		gnome2_icon_cache_update
	fi
}

pkg_postrm() {
	if use gtk; then
		gnome2_schemas_update
		gnome2_icon_cache_update
	fi
}
