# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtk+/gtk+-2.24.25.ebuild,v 1.11 2015/01/02 12:10:59 ago Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit eutils flag-o-matic gnome2 multilib virtualx autotools readme.gentoo multilib-minimal

DESCRIPTION="Gimp ToolKit +"
HOMEPAGE="http://www.gtk.org/"

LICENSE="LGPL-2+"
SLOT="2"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="aqua cups debug examples +introspection test vim-syntax xinerama"

# NOTE: cairo[svg] dep is due to bug 291283 (not patched to avoid eautoreconf)
COMMON_DEPEND="
	!aqua? (
		>=x11-libs/libXrender-0.9.8[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXi-1.7.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.4.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXcursor-1.1.14[${MULTILIB_USEDEP}]
		>=x11-libs/libXfixes-5.0.1[${MULTILIB_USEDEP}]
		>=x11-libs/libXcomposite-0.4.4-r1[${MULTILIB_USEDEP}]
		>=x11-libs/libXdamage-1.1.4-r1[${MULTILIB_USEDEP}]
		>=x11-libs/cairo-1.12.14-r4:=[X,svg,${MULTILIB_USEDEP}]
		>=x11-libs/gdk-pixbuf-2.30.7:2[X,introspection?,${MULTILIB_USEDEP}]
	)
	aqua? (
		>=x11-libs/cairo-1.6:=[aqua,svg]
		x11-libs/gdk-pixbuf:2[introspection?]
	)
	xinerama? ( >=x11-libs/libXinerama-1.1.3[${MULTILIB_USEDEP}] )
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.36.3[introspection?,${MULTILIB_USEDEP}]
	>=dev-libs/atk-2.10.0[introspection?,${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}]
	x11-misc/shared-mime-info
	cups? ( >=net-print/cups-1.7.1-r2:=[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-0.9.3 )
	!<gnome-base/gail-1000
"
DEPEND="${COMMON_DEPEND}
	dev-libs/gobject-introspection-common
	sys-devel/gettext
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	!aqua? (
		>=x11-proto/xextproto-7.2.1-r1[${MULTILIB_USEDEP}]
		>=x11-proto/xproto-7.0.24[${MULTILIB_USEDEP}]
		>=x11-proto/inputproto-2.3[${MULTILIB_USEDEP}]
		>=x11-proto/damageproto-1.2.1-r1[${MULTILIB_USEDEP}]
	)
	xinerama? ( >=x11-proto/xineramaproto-1.2.1-r1[${MULTILIB_USEDEP}] )
	>=dev-util/gtk-doc-am-1.20
	test? (
		x11-themes/hicolor-icon-theme
		media-fonts/font-misc-misc
		media-fonts/font-cursor-misc )
"

# gtk+-2.24.8 breaks Alt key handling in <=x11-libs/vte-0.28.2:0
# Add blocker against old gtk-builder-convert to be sure we maintain both
# in sync.
RDEPEND="${COMMON_DEPEND}
	!<dev-util/gtk-builder-convert-${PV}
	!<x11-libs/vte-0.28.2-r201:0
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-gtklibs-20140508
		!app-emulation/emul-linux-x86-gtklibs[-abi_x86_32(-)]
	)
"
PDEPEND="vim-syntax? ( app-vim/gtk-syntax )"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="To make the gtk2 file chooser use 'current directory' mode by default,
edit ~/.config/gtk-2.0/gtkfilechooser.ini to contain the following:
[Filechooser Settings]
StartupMode=cwd"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/gtk-query-immodules-2.0
)

strip_builddir() {
	local rule=$1
	shift
	local directory=$1
	shift
	sed -e "s/^\(${rule} =.*\)${directory}\(.*\)$/\1\2/" -i $@ \
		|| die "Could not strip director ${directory} from build."
}

set_gtk2_confdir() {
	# An arch specific config directory is used on multilib systems
	GTK2_CONFDIR="/etc/gtk-2.0/${CHOST}"
}

src_prepare() {
	# Fix building due to moved definition, upstream bug #704766
	epatch "${FILESDIR}"/${PN}-2.24.20-darwin-quartz-pasteboard.patch

	# Fix tests running when building out of sources, bug #510596
	epatch "${FILESDIR}"/${PN}-2.24.24-out-of-source.patch

	# marshalers code was pre-generated with glib-2.31, upstream bug #671763
	rm -v gdk/gdkmarshalers.c gtk/gtkmarshal.c gtk/gtkmarshalers.c \
		perf/marshalers.c || die

	# Stop trying to build unmaintained docs, bug #349754
	strip_builddir SUBDIRS tutorial docs/Makefile.am docs/Makefile.in
	strip_builddir SUBDIRS faq docs/Makefile.am docs/Makefile.in

	# -O3 and company cause random crashes in applications. Bug #133469
	replace-flags -O3 -O2
	strip-flags

	if ! use test; then
		# don't waste time building tests
		strip_builddir SRC_SUBDIRS tests Makefile.{am,in}
		strip_builddir SUBDIRS tests gdk/Makefile.{am,in} gtk/Makefile.{am,in}
	else
		# Non-working test in gentoo's env
		sed 's:\(g_test_add_func ("/ui-tests/keys-events.*\):/*\1*/:g' \
			-i gtk/tests/testing.c || die "sed 1 failed"

		# Cannot work because glib is too clever to find real user's home
		# gentoo bug #285687, upstream bug #639832
		# XXX: /!\ Pay extra attention to second sed when bumping /!\
		sed '/TEST_PROGS.*recentmanager/d' -i gtk/tests/Makefile.am \
			|| die "failed to disable recentmanager test (1)"
		sed '/^TEST_PROGS =/,+3 s/recentmanager//' -i gtk/tests/Makefile.in \
			|| die "failed to disable recentmanager test (2)"
		sed 's:\({ "GtkFileChooserButton".*},\):/*\1*/:g' -i gtk/tests/object.c \
			|| die "failed to disable recentmanager test (3)"

		# Skip tests known to fail
		# https://bugzilla.gnome.org/show_bug.cgi?id=646609
		sed -e '/g_test_add_func.*test_text_access/s:^://:' \
			-i "${S}/gtk/tests/testing.c" || die

		# https://bugzilla.gnome.org/show_bug.cgi?id=617473
		sed -i -e 's:pltcheck.sh:$(NULL):g' \
			gtk/Makefile.am || die

		# UI tests require immodules already installed; bug #413185
		if ! has_version 'x11-libs/gtk+:2'; then
			ewarn "Disabling UI tests because this is the first install of"
			ewarn "gtk+:2 on this machine. Please re-run the tests after $P"
			ewarn "has been installed."
			sed '/g_test_add_func.*ui-tests/ d' \
				-i gtk/tests/testing.c || die "sed 2 failed"
		fi
	fi

	if ! use examples; then
		# don't waste time building demos
		strip_builddir SRC_SUBDIRS demos Makefile.am Makefile.in
	fi

	epatch_user

	eautoreconf

	gnome2_src_prepare
}

multilib_src_configure() {
	[[ ${ABI} == ppc64 ]] && append-flags -mminimal-toc

	# Passing --disable-debug is not recommended for production use
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		$(usex aqua --with-gdktarget=quartz --with-gdktarget=x11) \
		$(usex aqua "" --with-xinput) \
		$(usex debug --enable-debug=yes "") \
		$(use_enable cups cups auto) \
		$(multilib_native_use_enable introspection) \
		$(use_enable xinerama) \
		--disable-papi \
		CUPS_CONFIG="${EPREFIX}/usr/bin/${CHOST}-cups-config"

	# work-around gtk-doc out-of-source brokedness
	if multilib_is_native_abi; then
		local d
		for d in gdk gtk libgail-util; do
			ln -s "${S}"/docs/reference/${d}/html docs/reference/${d}/html || die
		done
	fi
}

multilib_src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check
}

multilib_src_install() {
	gnome2_src_install

	# add -framework Carbon to the .pc files
	use aqua && for i in gtk+-2.0.pc gtk+-quartz-2.0.pc gtk+-unix-print-2.0.pc; do
		sed -i -e "s:Libs\: :Libs\: -framework Carbon :" "${ED%/}"/usr/lib/pkgconfig/$i || die "sed failed"
	done
}

multilib_src_install_all() {
	# see bug #133241
	echo 'gtk-fallback-icon-theme = "gnome"' > "${T}/gtkrc"
	insinto /usr/share/gtk-2.0
	doins "${T}"/gtkrc

	dodoc AUTHORS ChangeLog* HACKING NEWS* README*

	# dev-util/gtk-builder-convert split off into a separate package, #402905
	rm "${ED}"usr/bin/gtk-builder-convert || die

	readme.gentoo_create_doc
}

pkg_postinst() {
	set_gtk2_confdir

	multilib_pkg_postinst() {
		"${CHOST}"-gtk-query-immodules-2.0 --update-cache \
			|| die "Update immodules cache failed (for ${ABI})"
	}
	multilib_parallel_foreach_abi multilib_pkg_postinst

	if [ -e "${EROOT%/}/etc/gtk-2.0/gtk.immodules" ]; then
		elog "File /etc/gtk-2.0/gtk.immodules has been moved to \$CHOST"
		elog "aware location. Removing deprecated file."
		rm -f ${EROOT%/}/etc/gtk-2.0/gtk.immodules
	fi

	if [ -e "${EROOT%/}${GTK2_CONFDIR}/gtk.immodules" ]; then
		elog "File /etc/gtk-2.0/gtk.immodules has been moved to"
		elog "${EROOT%/}/usr/$(get_libdir)/gtk-2.0/2.10.0/immodules.cache"
		elog "Removing deprecated file."
		rm -f ${EROOT%/}${GTK2_CONFDIR}/gtk.immodules
	fi

	# pixbufs are now handled by x11-libs/gdk-pixbuf
	if [ -e "${EROOT%/}${GTK2_CONFDIR}/gdk-pixbuf.loaders" ]; then
		elog "File ${EROOT%/}${GTK2_CONFDIR}/gdk-pixbuf.loaders is now handled by x11-libs/gdk-pixbuf"
		elog "Removing deprecated file."
		rm -f ${EROOT%/}${GTK2_CONFDIR}/gdk-pixbuf.loaders
	fi

	# two checks needed since we dropped multilib conditional
	if [ -e "${EROOT%/}/etc/gtk-2.0/gdk-pixbuf.loaders" ]; then
		elog "File ${EROOT%/}/etc/gtk-2.0/gdk-pixbuf.loaders is now handled by x11-libs/gdk-pixbuf"
		elog "Removing deprecated file."
		rm -f ${EROOT%/}/etc/gtk-2.0/gdk-pixbuf.loaders
	fi

	if [ -e "${EROOT%/}"/usr/lib/gtk-2.0/2.[^1]* ]; then
		elog "You need to rebuild ebuilds that installed into" "${EROOT%/}"/usr/lib/gtk-2.0/2.[^1]*
		elog "to do that you can use qfile from portage-utils:"
		elog "emerge -va1 \$(qfile -qC ${EPREFIX}/usr/lib/gtk-2.0/2.[^1]*)"
	fi

	if ! has_version "app-text/evince"; then
		elog "Please install app-text/evince for print preview functionality."
		elog "Alternatively, check \"gtk-print-preview-command\" documentation and"
		elog "add it to your gtkrc."
	fi

	readme.gentoo_print_elog
}
