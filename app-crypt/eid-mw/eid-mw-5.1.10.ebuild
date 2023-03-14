# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop gnome2-utils xdg-utils

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
		x11-libs/gtk+:3
		dev-libs/libxml2
		net-misc/curl[ssl]
		net-libs/libproxy
		>=app-crypt/pinentry-1.1.0-r4[gtk]
	)
	p11-kit? ( app-crypt/p11-kit )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

REQUIRED_USE="dialogs? ( gtk )"

src_prepare() {
	default

	# Buggy internal versioning when autoreconf a tarball release.
	# Weird numbering is required otherwise we get a seg fault in
	# about-eid-mw program.
	echo "${PV}-v${PV}" > .version

	# See bug #862306
	sed -i \
		-e 's:PACKAGE_VERSION:MAINVERSION:' \
		cardcomm/pkcs11/src/libbeidpkcs11.pc.in || die

	# xpi module : we don't want it anymore
	sed -i -e '/SUBDIRS/ s:plugins_tools/xpi ::' Makefile.am || die
	sed -i -e '/plugins_tools\/xpi/ d' configure.ac || die

	# hardcoded lsb_info
	sed -i \
		-e "s:get_lsb_info('i'):strdup(_(\"Gentoo\")):" \
		-e "s:get_lsb_info('r'):strdup(_(\"n/a\")):" \
		-e "s:get_lsb_info('c'):strdup(_(\"n/a\")):" \
		plugins_tools/aboutmw/gtk/about-main.c || die

	# Fix libdir for pkcs11_manifestdir
	sed -i \
		-e "/pkcs11_manifestdir/ s:prefix)/lib:libdir):" \
		cardcomm/pkcs11/src/Makefile.am || die

	# See bug #732994
	sed -i \
		-e '/LDFLAGS="/ s:$CPPFLAGS:$LDFLAGS:' \
		configure.ac || die

	# See bug #751472
	eapply "${FILESDIR}/use-printf-in-Makefile.patch"

	# See bug #811270 (remove uml build)
	sed -i \
		-e 's:cardlayer/uml::' \
		cardcomm/pkcs11/src/Makefile.am || die
	sed -i \
		-e 's:uml::' \
		plugins_tools/eid-viewer/Makefile.am || die

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
		xdg_desktop_database_update
		xdg_icon_cache_update

		local peimpl=$(eselect --brief --colour=no pinentry show)
		case "${peimpl}" in
		*gnome*|*qt*) ;;
		*)	ewarn "The pinentry front-end currently selected is not supported by eid-mw."
			ewarn "You may be prompted for your pin code in an inaccessible shell!!"
			ewarn "Please select pinentry-gnome3 as default pinentry provider:"
			ewarn " # eselect pinentry set pinentry-gnome3"
		;;
		esac
	fi
}

pkg_postrm() {
	if use gtk; then
		gnome2_schemas_update
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}
