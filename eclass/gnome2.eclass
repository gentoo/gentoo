# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gnome2.eclass
# @MAINTAINER:
# gnome@gentoo.org
# @BLURB: Provides phases for Gnome/Gtk+ based packages.
# @DESCRIPTION:
# Exports portage base functions used by ebuilds written for packages using the
# GNOME framework. For additional functions, see gnome2-utils.eclass.

# @ECLASS-VARIABLE: GNOME2_EAUTORECONF
# @DEFAULT_UNSET
# @DESCRIPTION:
# Run eautoreconf instead of only elibtoolize
GNOME2_EAUTORECONF=${GNOME2_EAUTORECONF:-""}

[[ ${GNOME2_EAUTORECONF} == 'yes' ]] && inherit autotools
inherit eutils libtool gnome.org gnome2-utils xdg

case "${EAPI:-0}" in
	4|5)
		EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_install pkg_preinst pkg_postinst pkg_postrm
		;;
	6)
		EXPORT_FUNCTIONS src_prepare src_configure src_compile src_install pkg_preinst pkg_postinst pkg_postrm
		;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

# @ECLASS-VARIABLE: DOCS
# @DEFAULT_UNSET
# @DESCRIPTION:
# String containing documents passed to dodoc command for eapi4.
# In eapi5 we rely on einstalldocs (from eutils.eclass) and for newer EAPIs we
# follow PMS spec.

# @ECLASS-VARIABLE: ELTCONF
# @DEFAULT_UNSET
# @DESCRIPTION:
# Extra options passed to elibtoolize
ELTCONF=${ELTCONF:-""}

# @ECLASS-VARIABLE: G2CONF
# @DEFAULT_UNSET
# @DESCRIPTION:
# Extra configure opts passed to econf.
# Deprecated, pass extra arguments to gnome2_src_configure.
# Banned in eapi6 and newer.
if has ${EAPI:-0} 4 5; then
	G2CONF=${G2CONF:-""}
fi

# @ECLASS-VARIABLE: GCONF_DEBUG
# @DEFAULT_UNSET
# @DESCRIPTION:
# Whether to handle debug or not.
# Some gnome applications support various levels of debugging (yes, no, minimum,
# etc), but using --disable-debug also removes g_assert which makes debugging
# harder. This variable should be set to yes for such packages for the eclass
# to handle it properly. It will enable minimal debug with USE=-debug.
# Note that this is most commonly found in configure.ac as GNOME_DEBUG_CHECK.
#
# Banned since eapi6 as upstream is moving away from this obsolete macro in favor
# of autoconf-archive macros, that do not expose this issue (bug #270919)
if has ${EAPI:-0} 4 5; then
	if [[ ${GCONF_DEBUG} != "no" ]]; then
		IUSE="debug"
	fi
fi

# @ECLASS-VARIABLE: GNOME2_ECLASS_GIO_MODULES
# @INTERNAL
# @DESCRIPTION:
# Array containing glib GIO modules

# @ECLASS-VARIABLE: GNOME2_LA_PUNT
# @DESCRIPTION:
# For eapi4 it sets if we should delete ALL or none of the .la files
# For eapi5 and newer it relies on prune_libtool_files (from eutils.eclass)
# for this. Available values for GNOME2_LA_PUNT:
# - "no": will not clean any .la files
# - "yes": will run prune_libtool_files --modules
# - If it is not set, it will run prune_libtool_files
if has ${EAPI:-0} 4; then
	GNOME2_LA_PUNT=${GNOME2_LA_PUNT:-"no"}
else
	GNOME2_LA_PUNT=${GNOME2_LA_PUNT:-""}
fi

# @FUNCTION: gnome2_src_unpack
# @DESCRIPTION:
# Stub function for old EAPI.
gnome2_src_unpack() {
	if has ${EAPI:-0} 4 5; then
		unpack ${A}
		cd "${S}"
	else
		die "gnome2_src_unpack is banned from eapi6"
	fi
}

# @FUNCTION: gnome2_src_prepare
# @DESCRIPTION:
# Prepare environment for build, fix build of scrollkeeper documentation,
# run elibtoolize.
gnome2_src_prepare() {
	xdg_src_prepare

	# Prevent assorted access violations and test failures
	gnome2_environment_reset

	# Prevent scrollkeeper access violations
	# We stop to run it from eapi6 as scrollkeeper helpers from
	# rarian are not running anything and, then, access violations
	# shouldn't occur.
	has ${EAPI:-0} 4 5 && gnome2_omf_fix

	# Disable all deprecation warnings
	gnome2_disable_deprecation_warning

	# Run libtoolize or eautoreconf, bug #591584
	# https://bugzilla.gnome.org/show_bug.cgi?id=655517
	if [[ ${GNOME2_EAUTORECONF} == 'yes' ]]; then
		eautoreconf
	else
		elibtoolize ${ELTCONF}
	fi
}

# @FUNCTION: gnome2_src_configure
# @DESCRIPTION:
# Gnome specific configure handling
gnome2_src_configure() {
	# Deprecated for a long time now and banned since eapi6, see Gnome team policies
	if [[ -n ${G2CONF} ]] ; then
		if has ${EAPI:-0} 4 5; then
			eqawarn "G2CONF set, please review documentation at https://wiki.gentoo.org/wiki/Project:GNOME/Gnome_Team_Ebuild_Policies#G2CONF_and_src_configure"
		else
			die "G2CONF set, please review documentation at https://wiki.gentoo.org/wiki/Project:GNOME/Gnome_Team_Ebuild_Policies#G2CONF_and_src_configure"
		fi
	fi

	local g2conf=()

	if has ${EAPI:-0} 4 5; then
		if [[ ${GCONF_DEBUG} != 'no' ]] ; then
			if use debug ; then
				g2conf+=( --enable-debug=yes )
			fi
		fi
	else
		if [[ -n ${GCONF_DEBUG} ]] ; then
			die "GCONF_DEBUG is banned since eapi6 in favor of each ebuild taking care of the proper handling of debug configure option"
		fi
	fi

	# Starting with EAPI=5, we consider packages installing gtk-doc to be
	# handled by adding DEPEND="dev-util/gtk-doc-am" which provides tools to
	# relink URLs in documentation to already installed documentation.
	# This decision also greatly helps with constantly broken doc generation.
	# Remember to drop 'doc' USE flag from your package if it was only used to
	# rebuild docs.
	# Preserve old behavior for older EAPI.
	if grep -q "enable-gtk-doc" "${ECONF_SOURCE:-.}"/configure ; then
		if has ${EAPI:-0} 4 && in_iuse doc ; then
			g2conf+=( $(use_enable doc gtk-doc) )
		else
			g2conf+=( --disable-gtk-doc )
		fi
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

	# Pass --disable-silent-rules when possible (not needed since eapi5), bug #429308
	if has ${EAPI:-0} 4; then
		if grep -q "disable-silent-rules" "${ECONF_SOURCE:-.}"/configure; then
			g2conf+=( --disable-silent-rules )
		fi
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

	# Pass --docdir with proper directory, bug #482646 (not needed since eapi6)
	if has ${EAPI:-0} 4 5; then
		if grep -q "^ *--docdir=" "${ECONF_SOURCE:-.}"/configure; then
			g2conf+=( --docdir="${EPREFIX}"/usr/share/doc/${PF} )
		fi
	fi

	# Avoid sandbox violations caused by gnome-vfs (bug #128289 and #345659)
	if has ${EAPI:-0} 4 5; then
		addwrite "$(unset HOME; echo ~)/.gnome2"
	else
		addpredict "$(unset HOME; echo ~)/.gnome2"
	fi

	if has ${EAPI:-0} 4 5; then
		econf ${g2conf[@]} ${G2CONF} "$@"
	else
		econf ${g2conf[@]} "$@"
	fi
}

# @FUNCTION: gnome2_src_compile
# @DESCRIPTION:
# Only default src_compile for now
gnome2_src_compile() {
	if has ${EAPI:-0} 4 5; then
		emake
	else
		default
	fi
}

# @FUNCTION: gnome2_src_install
# @DESCRIPTION:
# Gnome specific install. Handles typical GConf and scrollkeeper setup
# in packages and removal of .la files if requested
gnome2_src_install() {
	# we must delay gconf schema installation due to sandbox
	export GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL="1"

	local sk_tmp_dir="/var/lib/scrollkeeper"
	# scrollkeeper-update from rarian doesn't do anything. Then, since eapi6
	# we stop taking care of it
	#
	# if this is not present, scrollkeeper-update may segfault and
	# create bogus directories in /var/lib/
	if has ${EAPI:-0} 4 5; then
		dodir "${sk_tmp_dir}" || die "dodir failed"
		emake DESTDIR="${D}" "scrollkeeper_localstate_dir=${ED}${sk_tmp_dir} " "$@" install || die "install failed"
	else
		default
	fi

	unset GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL

	# Handle documentation as 'default' for eapi5, bug #373131
	# Since eapi6 this is handled by default on its own plus MAINTAINERS and HACKING
	# files that are really common in gnome packages (bug #573390)
	if has ${EAPI:-0} 4; then
		# Manual document installation
		if [[ -n "${DOCS}" ]]; then
			dodoc ${DOCS} || die "dodoc failed"
		fi
	elif has ${EAPI:-0} 5; then
		einstalldocs
	else
		local d
		for d in HACKING MAINTAINERS; do
			[[ -s "${d}" ]] && dodoc "${d}"
		done
	fi

	# Do not keep /var/lib/scrollkeeper because:
	# 1. The scrollkeeper database is regenerated at pkg_postinst()
	# 2. ${ED}/var/lib/scrollkeeper contains only indexes for the current pkg
	#    thus it makes no sense if pkg_postinst ISN'T run for some reason.
	rm -rf "${ED}${sk_tmp_dir}"
	rmdir "${ED}/var/lib" 2>/dev/null
	rmdir "${ED}/var" 2>/dev/null

	# Make sure this one doesn't get in the portage db
	rm -fr "${ED}/usr/share/applications/mimeinfo.cache"

	# Delete all .la files
	if has ${EAPI:-0} 4; then
		if [[ "${GNOME2_LA_PUNT}" != "no" ]]; then
			ebegin "Removing .la files"
			if ! use_if_iuse static-libs ; then
				find "${D}" -name '*.la' -exec rm -f {} + || die "la file removal failed"
			fi
			eend
		fi
	else
		case "${GNOME2_LA_PUNT}" in
			yes)    prune_libtool_files --modules;;
			no)     ;;
			*)      prune_libtool_files;;
		esac
	fi
}

# @FUNCTION: gnome2_pkg_preinst
# @DESCRIPTION:
# Finds Icons, GConf and GSettings schemas for later handling in pkg_postinst
gnome2_pkg_preinst() {
	xdg_pkg_preinst
	gnome2_gconf_savelist
	gnome2_icon_savelist
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
	if [[ -n ${GNOME2_ECLASS_ICONS} ]]; then
		gnome2_icon_cache_update
	fi
	if [[ -z ${GNOME2_ECLASS_GLIB_SCHEMAS} ]]; then
		gnome2_schemas_update
	fi
	gnome2_scrollkeeper_update
	gnome2_gdk_pixbuf_update

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
	if [[ -n ${GNOME2_ECLASS_ICONS} ]]; then
		gnome2_icon_cache_update
	fi
	if [[ -z ${GNOME2_ECLASS_GLIB_SCHEMAS} ]]; then
		gnome2_schemas_update
	fi
	gnome2_scrollkeeper_update

	if [[ ${#GNOME2_ECLASS_GIO_MODULES[@]} -gt 0 ]]; then
		gnome2_giomodule_cache_update
	fi
}
