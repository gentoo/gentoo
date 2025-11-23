# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gnome2.eclass
# @MAINTAINER:
# gnome@gentoo.org
# @SUPPORTED_EAPIS: 7 8
# @PROVIDES: gnome2-utils
# @BLURB: Provides phases for Gnome/Gtk+ based packages.
# @DESCRIPTION:
# Exports portage base functions used by ebuilds written for packages using the
# GNOME framework. For additional functions, see gnome2-utils.eclass.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_GNOME2_ECLASS} ]]; then
_GNOME2_ECLASS=1

# @ECLASS_VARIABLE: GNOME2_EAUTORECONF
# @DEFAULT_UNSET
# @DESCRIPTION:
# Run eautoreconf instead of only elibtoolize if set to "yes".

[[ ${GNOME2_EAUTORECONF} == yes ]] && inherit autotools

inherit libtool gnome.org gnome2-utils xdg

# @ECLASS_VARIABLE: ELTCONF
# @DEFAULT_UNSET
# @DESCRIPTION:
# Extra options passed to elibtoolize

# @ECLASS_VARIABLE: GNOME2_ECLASS_GIO_MODULES
# @INTERNAL
# @DESCRIPTION:
# Array containing glib GIO modules

# @ECLASS_VARIABLE: GNOME2_LA_PUNT
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set to "no", no .la files will be cleaned, otherwise
# will run "find ... -delete" in src_install.

# @FUNCTION: gnome2_src_prepare
# @DESCRIPTION:
# Prepare environment for build, fix build of scrollkeeper documentation,
# run elibtoolize.
gnome2_src_prepare() {
	default

	# Prevent assorted access violations and test failures
	gnome2_environment_reset

	# Disable all deprecation warnings
	gnome2_disable_deprecation_warning

	# Run libtoolize or eautoreconf, bug #591584
	# https://bugzilla.gnome.org/show_bug.cgi?id=655517
	if [[ ${GNOME2_EAUTORECONF} == yes ]]; then
		eautoreconf
	else
		elibtoolize ${ELTCONF}
	fi
}

# @FUNCTION: gnome2_src_configure
# @DESCRIPTION:
# Gnome specific configure handling
gnome2_src_configure() {
	local g2conf=()

	# We consider packages installing gtk-doc to be handled by adding
	# DEPEND="dev-build/gtk-doc-am" which provides tools to relink URLs in
	# documentation to already installed documentation.  This decision also
	# greatly helps with constantly broken doc generation.
	# Remember to drop 'doc' USE flag from your package if it was only used to
	# rebuild docs.
	if grep -q "enable-gtk-doc" "${ECONF_SOURCE:-.}"/configure ; then
		g2conf+=( --disable-gtk-doc )
	fi

	# Pass --disable-maintainer-mode when needed
	if grep -q "^[[:space:]]*AM_MAINTAINER_MODE(\[enable\])" \
		"${ECONF_SOURCE:-.}"/configure.*; then
		g2conf+=( --disable-maintainer-mode )
	fi

	# Pass --disable-scrollkeeper when possible
	if grep -q "disable-scrollkeeper" "${ECONF_SOURCE:-.}"/configure; then
		g2conf+=( --disable-scrollkeeper )
	fi

	# Pass --disable-schemas-install when possible
	if grep -q "disable-schemas-install" "${ECONF_SOURCE:-.}"/configure; then
		g2conf+=( --disable-schemas-install )
	fi

	# Pass --disable-schemas-compile when possible
	if grep -q "disable-schemas-compile" "${ECONF_SOURCE:-.}"/configure; then
		g2conf+=( --disable-schemas-compile )
	fi

	# Pass --disable-update-mimedb when possible
	if grep -q "disable-update-mimedb" "${ECONF_SOURCE:-.}"/configure; then
		g2conf+=( --disable-update-mimedb )
	fi

	# Pass --enable-compile-warnings=minimum as we don't want -Werror* flags, bug #471336
	if grep -q "enable-compile-warnings" "${ECONF_SOURCE:-.}"/configure; then
		g2conf+=( --enable-compile-warnings=minimum )
	fi

	# Avoid sandbox violations caused by gnome-vfs (bug #128289 and #345659)
	addpredict "$(unset HOME; echo ~)/.gnome2"

	econf ${g2conf[@]} "$@"
}

# @FUNCTION: gnome2_src_compile
# @DESCRIPTION:
# Only default src_compile for now
gnome2_src_compile() {
	default
}

# @FUNCTION: gnome2_src_install
# @DESCRIPTION:
# Gnome specific install. Handles typical GConf and scrollkeeper setup
# in packages and removal of .la files if requested
gnome2_src_install() {
	# we must delay gconf schema installation due to sandbox
	export GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL="1"

	local sk_tmp_dir="/var/lib/scrollkeeper"
	# scrollkeeper-update from rarian doesn't do anything.
	#
	# if this is not present, scrollkeeper-update may segfault and
	# create bogus directories in /var/lib/
	default

	unset GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL

	# Install MAINTAINERS and HACKING which are really common
	# in gnome packages (bug #573390)
	local d
	for d in HACKING MAINTAINERS; do
		[[ -s ${d} ]] && dodoc "${d}"
	done

	# Do not keep /var/lib/scrollkeeper because:
	# 1. The scrollkeeper database is regenerated at pkg_postinst()
	# 2. ${ED}/var/lib/scrollkeeper contains only indexes for the current pkg
	#    thus it makes no sense if pkg_postinst ISN'T run for some reason.
	rm -rf "${ED}${sk_tmp_dir}" || die
	rmdir "${ED}/var/lib" 2>/dev/null
	rmdir "${ED}/var" 2>/dev/null

	# Make sure this one doesn't get in the portage db
	rm -rf "${ED}/usr/share/applications/mimeinfo.cache" || die

	# Delete all .la files
	if [[ ${GNOME2_LA_PUNT} != no ]]; then
		find "${ED}" -type f -name '*.la' -delete || die
	fi
}

# @FUNCTION: gnome2_pkg_preinst
# @DESCRIPTION:
# Finds Icons, GConf and GSettings schemas for later handling in pkg_postinst
gnome2_pkg_preinst() {
	xdg_pkg_preinst
	gnome2_gconf_savelist
	gnome2_schemas_savelist
	gnome2_scrollkeeper_savelist
	gnome2_gdk_pixbuf_savelist

	local f

	GNOME2_ECLASS_GIO_MODULES=()
	while IFS= read -r -d '' f; do
		GNOME2_ECLASS_GIO_MODULES+=( ${f} )
	done < <(cd "${D}" && find usr/$(get_libdir)/gio/modules -type f -print0 2>/dev/null)

	export GNOME2_ECLASS_GIO_MODULES
}

# @FUNCTION: gnome2_pkg_postinst
# @DESCRIPTION:
# Handle scrollkeeper, GConf, GSettings, Icons, desktop and mime
# database updates.
gnome2_pkg_postinst() {
	xdg_pkg_postinst
	gnome2_gconf_install
	if [[ -n ${GNOME2_ECLASS_GLIB_SCHEMAS} ]]; then
		gnome2_schemas_update
	fi
	gnome2_scrollkeeper_update
	if [[ -n ${GNOME2_ECLASS_GDK_PIXBUF_LOADERS} ]]; then
		gnome2_gdk_pixbuf_update
	fi

	if [[ ${#GNOME2_ECLASS_GIO_MODULES[@]} -gt 0 ]]; then
		gnome2_giomodule_cache_update
	fi
}

# # FIXME Handle GConf schemas removal
#gnome2_pkg_prerm() {
#	gnome2_gconf_uninstall
#}

# @FUNCTION: gnome2_pkg_postrm
# @DESCRIPTION:
# Handle scrollkeeper, GSettings, Icons, desktop and mime database updates.
gnome2_pkg_postrm() {
	xdg_pkg_postrm
	if [[ -n ${GNOME2_ECLASS_GLIB_SCHEMAS} ]]; then
		gnome2_schemas_update
	fi
	gnome2_scrollkeeper_update

	if [[ ${#GNOME2_ECLASS_GIO_MODULES[@]} -gt 0 ]]; then
		gnome2_giomodule_cache_update
	fi
}

fi

EXPORT_FUNCTIONS src_prepare src_configure src_compile src_install pkg_preinst pkg_postinst pkg_postrm
