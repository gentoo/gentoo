# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: gnome2.eclass
# @MAINTAINER:
# gnome@gentoo.org
# @BLURB: Provides phases for Gnome/Gtk+ based packages.
# @DESCRIPTION:
# Exports portage base functions used by ebuilds written for packages using the
# GNOME framework. For additional functions, see gnome2-utils.eclass.

inherit eutils fdo-mime libtool gnome.org gnome2-utils

case "${EAPI:-0}" in
	4|5)
		EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_install pkg_preinst pkg_postinst pkg_postrm
		;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

# @ECLASS-VARIABLE: G2CONF
# @DEFAULT_UNSET
# @DESCRIPTION:
# Extra configure opts passed to econf
G2CONF=${G2CONF:-""}

# @ECLASS-VARIABLE: GNOME2_LA_PUNT
# @DESCRIPTION:
# Should we delete ALL the .la files?
# NOT to be used without due consideration.
if has ${EAPI:-0} 4; then
	GNOME2_LA_PUNT=${GNOME2_LA_PUNT:-"no"}
else
	GNOME2_LA_PUNT=${GNOME2_LA_PUNT:-""}
fi

# @ECLASS-VARIABLE: ELTCONF
# @DEFAULT_UNSET
# @DESCRIPTION:
# Extra options passed to elibtoolize
ELTCONF=${ELTCONF:-""}

# @ECLASS-VARIABLE: DOCS
# @DEFAULT_UNSET
# @DESCRIPTION:
# String containing documents passed to dodoc command.

# @ECLASS-VARIABLE: GCONF_DEBUG
# @DEFAULT_UNSET
# @DESCRIPTION:
# Whether to handle debug or not.
# Some gnome applications support various levels of debugging (yes, no, minimum,
# etc), but using --disable-debug also removes g_assert which makes debugging
# harder. This variable should be set to yes for such packages for the eclass
# to handle it properly. It will enable minimal debug with USE=-debug.
# Note that this is most commonly found in configure.ac as GNOME_DEBUG_CHECK.


if [[ ${GCONF_DEBUG} != "no" ]]; then
	IUSE="debug"
fi

# @FUNCTION: gnome2_src_unpack
# @DESCRIPTION:
# Stub function for old EAPI.
gnome2_src_unpack() {
	unpack ${A}
	cd "${S}"
}

# @FUNCTION: gnome2_src_prepare
# @DESCRIPTION:
# Prepare environment for build, fix build of scrollkeeper documentation,
# run elibtoolize.
gnome2_src_prepare() {
	# Prevent assorted access violations and test failures
	gnome2_environment_reset

	# Prevent scrollkeeper access violations
	gnome2_omf_fix

	# Disable all deprecation warnings
	gnome2_disable_deprecation_warning

	# Run libtoolize
	elibtoolize ${ELTCONF}
}

# @FUNCTION: gnome2_src_configure
# @DESCRIPTION:
# Gnome specific configure handling
gnome2_src_configure() {
	# Update the GNOME configuration options
	if [[ ${GCONF_DEBUG} != 'no' ]] ; then
		if use debug ; then
			G2CONF="--enable-debug=yes ${G2CONF}"
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
			G2CONF="$(use_enable doc gtk-doc) ${G2CONF}"
		else
			G2CONF="--disable-gtk-doc ${G2CONF}"
		fi
	fi

	# Pass --disable-maintainer-mode when needed
	if grep -q "^[[:space:]]*AM_MAINTAINER_MODE(\[enable\])" \
		"${ECONF_SOURCE:-.}"/configure.*; then
		G2CONF="--disable-maintainer-mode ${G2CONF}"
	fi

	# Pass --disable-scrollkeeper when possible
	if grep -q "disable-scrollkeeper" "${ECONF_SOURCE:-.}"/configure; then
		G2CONF="--disable-scrollkeeper ${G2CONF}"
	fi

	# Pass --disable-silent-rules when possible (not needed for eapi5), bug #429308
	if has ${EAPI:-0} 4; then
		if grep -q "disable-silent-rules" "${ECONF_SOURCE:-.}"/configure; then
			G2CONF="--disable-silent-rules ${G2CONF}"
		fi
	fi

	# Pass --disable-schemas-install when possible
	if grep -q "disable-schemas-install" "${ECONF_SOURCE:-.}"/configure; then
		G2CONF="--disable-schemas-install ${G2CONF}"
	fi

	# Pass --disable-schemas-compile when possible
	if grep -q "disable-schemas-compile" "${ECONF_SOURCE:-.}"/configure; then
		G2CONF="--disable-schemas-compile ${G2CONF}"
	fi

	# Pass --enable-compile-warnings=minimum as we don't want -Werror* flags, bug #471336
	if grep -q "enable-compile-warnings" "${ECONF_SOURCE:-.}"/configure; then
		G2CONF="--enable-compile-warnings=minimum ${G2CONF}"
	fi

	# Pass --docdir with proper directory, bug #482646
	if grep -q "^ *--docdir=" "${ECONF_SOURCE:-.}"/configure; then
		G2CONF="--docdir="${EPREFIX}"/usr/share/doc/${PF} ${G2CONF}"
	fi

	# Avoid sandbox violations caused by gnome-vfs (bug #128289 and #345659)
	addwrite "$(unset HOME; echo ~)/.gnome2"

	econf ${G2CONF} "$@"
}

# @FUNCTION: gnome2_src_compile
# @DESCRIPTION:
# Only default src_compile for now
gnome2_src_compile() {
	emake
}

# @FUNCTION: gnome2_src_install
# @DESCRIPTION:
# Gnome specific install. Handles typical GConf and scrollkeeper setup
# in packages and removal of .la files if requested
gnome2_src_install() {
	# if this is not present, scrollkeeper-update may segfault and
	# create bogus directories in /var/lib/
	local sk_tmp_dir="/var/lib/scrollkeeper"
	dodir "${sk_tmp_dir}" || die "dodir failed"

	# we must delay gconf schema installation due to sandbox
	export GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL="1"

	debug-print "Installing with 'make install'"
	emake DESTDIR="${D}" "scrollkeeper_localstate_dir=${ED}${sk_tmp_dir} " "$@" install || die "install failed"

	unset GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL

	# Handle documentation as 'default' for eapi5 and newer, bug #373131
	if has ${EAPI:-0} 4; then
		# Manual document installation
		if [[ -n "${DOCS}" ]]; then
			dodoc ${DOCS} || die "dodoc failed"
		fi
	else
		einstalldocs
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
	gnome2_gconf_savelist
	gnome2_icon_savelist
	gnome2_schemas_savelist
	gnome2_scrollkeeper_savelist
	gnome2_gdk_pixbuf_savelist
}

# @FUNCTION: gnome2_pkg_postinst
# @DESCRIPTION:
# Handle scrollkeeper, GConf, GSettings, Icons, desktop and mime
# database updates.
gnome2_pkg_postinst() {
	gnome2_gconf_install
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	gnome2_schemas_update
	gnome2_scrollkeeper_update
	gnome2_gdk_pixbuf_update
}

# # FIXME Handle GConf schemas removal
#gnome2_pkg_prerm() {
#	gnome2_gconf_uninstall
#}

# @FUNCTION: gnome2_pkg_postrm
# @DESCRIPTION:
# Handle scrollkeeper, GSettings, Icons, desktop and mime database updates.
gnome2_pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	gnome2_schemas_update
	gnome2_scrollkeeper_update
}
