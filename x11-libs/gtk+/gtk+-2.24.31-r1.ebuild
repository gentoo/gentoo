# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"

inherit autotools eutils flag-o-matic gnome2 multilib multilib-minimal readme.gentoo-r1 virtualx

DESCRIPTION="Gimp ToolKit +"
HOMEPAGE="http://www.gtk.org/"

LICENSE="LGPL-2+"
SLOT="2"
IUSE="aqua cups examples +introspection test vim-syntax xinerama"
REQUIRED_USE="
	xinerama? ( !aqua )
"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# Upstream wants us to do their job:
# https://bugzilla.gnome.org/show_bug.cgi?id=768663#c1
RESTRICT="test"

COMMON_DEPEND="
	>=dev-libs/atk-2.10.0[introspection?,${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.12.14-r4:=[aqua?,svg,${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.30.7:2[introspection?,${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.36.3[introspection?,${MULTILIB_USEDEP}]
	x11-misc/shared-mime-info

	cups? ( >=net-print/cups-1.7.1-r2:=[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-0.9.3:= )
	!aqua? (
		>=x11-libs/cairo-1.12.14-r4:=[aqua?,svg,X,${MULTILIB_USEDEP}]
		>=x11-libs/gdk-pixbuf-2.30.7:2[introspection?,X,${MULTILIB_USEDEP}]
		>=x11-libs/libXrender-0.9.8[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXi-1.7.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.5[${MULTILIB_USEDEP}]
		>=x11-libs/libXcursor-1.1.14[${MULTILIB_USEDEP}]
		>=x11-libs/libXfixes-5.0.1[${MULTILIB_USEDEP}]
		>=x11-libs/libXcomposite-0.4.4-r1[${MULTILIB_USEDEP}]
		>=x11-libs/libXdamage-1.1.4-r1[${MULTILIB_USEDEP}]
		xinerama? ( >=x11-libs/libXinerama-1.1.3[${MULTILIB_USEDEP}] )
	)
"
# docbook-4.1.2 and xsl required for man pages
# docbook-4.3 required for gtk-doc
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.1.2
	app-text/docbook-xml-dtd:4.3
	dev-libs/libxslt
	dev-libs/gobject-introspection-common
	>=dev-util/gtk-doc-am-1.20
	>=sys-devel/gettext-0.18.3[${MULTILIB_USEDEP}]
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	!aqua? (
		>=x11-proto/xextproto-7.2.1-r1[${MULTILIB_USEDEP}]
		>=x11-proto/xproto-7.0.24[${MULTILIB_USEDEP}]
		>=x11-proto/inputproto-2.3[${MULTILIB_USEDEP}]
		>=x11-proto/damageproto-1.2.1-r1[${MULTILIB_USEDEP}]
		xinerama? ( >=x11-proto/xineramaproto-1.2.1-r1[${MULTILIB_USEDEP}] )
	)
	test? (
		x11-themes/hicolor-icon-theme
		media-fonts/font-misc-misc
		media-fonts/font-cursor-misc )
"

# gtk+-2.24.8 breaks Alt key handling in <=x11-libs/vte-0.28.2:0
# Add blocker against old gtk-builder-convert to be sure we maintain both
# in sync.
RDEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-update-icon-cache-2
	!<gnome-base/gail-1000
	!<dev-util/gtk-builder-convert-${PV}
	!<x11-libs/vte-0.28.2-r201:0
	>=x11-themes/adwaita-icon-theme-3.14
	x11-themes/gnome-themes-standard
"
# librsvg for svg icons (PDEPEND to avoid circular dep), bug #547710
PDEPEND="
	x11-themes/gtk-engines-adwaita
	gnome-base/librsvg[${MULTILIB_USEDEP}]
	vim-syntax? ( app-vim/gtk-syntax )
"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="To make the gtk2 file chooser use 'current directory' mode by default,
edit ~/.config/gtk-2.0/gtkfilechooser.ini to contain the following:
[Filechooser Settings]
StartupMode=cwd"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/gtk-query-immodules-2.0$(get_exeext)
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
	# marshalers code was pre-generated with glib-2.31, upstream bug #662109
	rm -v gdk/gdkmarshalers.c gtk/gtkmarshal.c gtk/gtkmarshalers.c \
		perf/marshalers.c || die

	# Stop trying to build unmaintained docs, bug #349754, upstream bug #623150
	strip_builddir SUBDIRS tutorial docs/Makefile.{am,in}
	strip_builddir SUBDIRS faq docs/Makefile.{am,in}

	# -O3 and company cause random crashes in applications, bug #133469
	replace-flags -O3 -O2
	strip-flags

	if ! use test ; then
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
		strip_builddir SRC_SUBDIRS demos Makefile.{am,in}
	fi

	# Fix tests running when building out of sources, bug #510596, upstream bug #730319
	eapply "${FILESDIR}"/${PN}-2.24.24-out-of-source.patch

	# Rely on split gtk-update-icon-cache package, bug #528810
	eapply "${FILESDIR}"/${PN}-2.24.31-update-icon-cache.patch

	# Fix beep when overwriting at the end of a gtkentry, from gtk-2-24 branch
	eapply "${FILESDIR}"/${PN}-2.24.31-fix-gtkentry-beep.patch

	eautoreconf
	gnome2_src_prepare
}

multilib_src_configure() {
	[[ ${ABI} == ppc64 ]] && append-flags -mminimal-toc

	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		$(usex aqua --with-gdktarget=quartz --with-gdktarget=x11) \
		$(usex aqua "" --with-xinput) \
		$(use_enable cups cups auto) \
		$(multilib_native_use_enable introspection) \
		$(use_enable xinerama) \
		--disable-papi \
		--enable-man \
		--with-xml-catalog="${EPREFIX}"/etc/xml/catalog \
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
	virtx emake check
}

multilib_src_install() {
	gnome2_src_install
}

multilib_src_install_all() {
	# see bug #133241
	# Also set more default variables in sync with gtk3 and other distributions
	echo 'gtk-fallback-icon-theme = "gnome"' > "${T}/gtkrc"
	echo 'gtk-theme-name = "Adwaita"' >> "${T}/gtkrc"
	echo 'gtk-icon-theme-name = "gnome"' >> "${T}/gtkrc"
	echo 'gtk-cursor-theme-name = "Adwaita"' >> "${T}/gtkrc"

	insinto /usr/share/gtk-2.0
	doins "${T}"/gtkrc

	einstalldocs

	# dev-util/gtk-builder-convert split off into a separate package, #402905
	rm "${ED}"usr/bin/gtk-builder-convert || die
	rm "${ED}"usr/share/man/man1/gtk-builder-convert.* || die

	readme.gentoo_create_doc
}

pkg_preinst() {
	gnome2_pkg_preinst

	multilib_pkg_preinst() {
		# Make immodules.cache belongs to gtk+ alone
		local cache="usr/$(get_libdir)/gtk-2.0/2.10.0/immodules.cache"

		if [[ -e ${EROOT}${cache} ]]; then
			cp "${EROOT}"${cache} "${ED}"/${cache} || die
		else
			touch "${ED}"/${cache} || die
		fi
	}
	multilib_parallel_foreach_abi multilib_pkg_preinst
}

pkg_postinst() {
	gnome2_pkg_postinst

	multilib_pkg_postinst() {
		gnome2_query_immodules_gtk2 \
			|| die "Update immodules cache failed (for ${ABI})"
	}
	multilib_parallel_foreach_abi multilib_pkg_postinst

	set_gtk2_confdir

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

pkg_postrm() {
	gnome2_pkg_postrm

	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		multilib_pkg_postrm() {
			rm -f "${EROOT}"usr/$(get_libdir)/gtk-2.0/2.10.0/immodules.cache
		}
		multilib_foreach_abi multilib_pkg_postrm
	fi
}
