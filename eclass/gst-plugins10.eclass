# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: gst-plugins10.eclass
# @MAINTAINER:
# gstreamer@gentoo.org
# @AUTHOR:
# Gilles Dartiguelongue <eva@gentoo.org>
# Saleem Abdulrasool <compnerd@gentoo.org>
# foser <foser@gentoo.org>
# zaheerm <zaheerm@gentoo.org>
# @BLURB: Manages build for invididual ebuild for gst-plugins.
# @DESCRIPTION:
# Eclass to make external gst-plugins emergable on a per-plugin basis and
# to solve the problem with gst-plugins generating far too much unneeded
# dependancies.
#
# GStreamer consuming applications should depend on the specific plugins they
# need as defined in their source code.
#
# In case of spider usage, obtain recommended plugins to use from Gentoo
# developers responsible for gstreamer <gstreamer@gentoo.org> or the application
# developer.

inherit eutils multilib toolchain-funcs versionator

GST_EXPF=""
case "${EAPI:-0}" in
	2|3|4|5)
		GST_EXPF="src_configure src_compile src_install"
		;;
	1)
		GST_EXPF="src_compile src_install"
		;;
	0)
		die "EAPI=\"${EAPI:-0}\" is not supported anymore"
		;;
	*)
		die "EAPI=\"${EAPI}\" is not supported yet"
		;;
esac
EXPORT_FUNCTIONS ${GST_EXPF}

# @ECLASS-VARIABLE: GST_LA_PUNT
# @DESCRIPTION:
# Should we delete all the .la files?
# NOT to be used without due consideration.
# Defaults to no for EAPI < 5.
if has "${EAPI:-0}" 0 1 2 3; then
	: ${GST_LA_PUNT:="no"}
else
	: ${GST_LA_PUNT:="yes"}
fi

# @ECLASS-VARIABLE: GST_PLUGINS_BUILD
# @DESCRIPTION:
# Defines the plugins to be built.
# May be set by an ebuild and contain more than one indentifier, space
# seperated (only src_configure can handle mutiple plugins at this time).
: ${GST_PLUGINS_BUILD:=${PN/gst-plugins-/}}

# @ECLASS-VARIABLE: GST_PLUGINS_BUILD_DIR
# @DESCRIPTION:
# Actual build directory of the plugin.
# Most often the same as the configure switch name.
: ${GST_PLUGINS_BUILD_DIR:=${PN/gst-plugins-/}}

# @ECLASS-VARIABLE: GST_TARBALL_SUFFIX
# @DESCRIPTION:
# Most projects hosted on gstreamer.freedesktop.org mirrors provide tarballs as
# tar.bz2 or tar.xz. This eclass defaults to bz2 for EAPI 0, 1, 2, 3 and
# defaults to xz for everything else. This is because the gstreamer mirrors
# are moving to only have xz tarballs for new releases.
if has "${EAPI:-0}" 0 1 2 3; then
	: ${GST_TARBALL_SUFFIX:="bz2"}
else
	: ${GST_TARBALL_SUFFIX:="xz"}
fi

# Even though xz-utils are in @system, they must still be added to DEPEND; see
# http://archives.gentoo.org/gentoo-dev/msg_a0d4833eb314d1be5d5802a3b710e0a4.xml
if [[ ${GST_TARBALL_SUFFIX} == "xz" ]]; then
	DEPEND="${DEPEND} app-arch/xz-utils"
fi

# @ECLASS-VARIABLE: GST_ORG_MODULE
# @DESCRIPTION:
# Name of the module as hosted on gstreamer.freedesktop.org mirrors.
# Leave unset if package name matches module name.
: ${GST_ORG_MODULE:=$PN}

# @ECLASS-VARIABLE: GST_ORG_PVP
# @INTERNAL
# @DESCRIPTION:
# Major and minor numbers of the version number.
: ${GST_ORG_PVP:=$(get_version_component_range 1-2)}


DESCRIPTION="${BUILD_GST_PLUGINS} plugin for gstreamer"
HOMEPAGE="http://gstreamer.freedesktop.org/"
SRC_URI="http://gstreamer.freedesktop.org/src/${GST_ORG_MODULE}/${GST_ORG_MODULE}-${PV}.tar.${GST_TARBALL_SUFFIX}"

LICENSE="GPL-2"
case ${GST_ORG_PVP} in
	0.10) SLOT="0.10" ;;
	1.*) SLOT="1.0" ;;
	*) die "Unkown gstreamer release."
esac

S="${WORKDIR}/${GST_ORG_MODULE}-${PV}"

RDEPEND="
	>=dev-libs/glib-2.6:2
	media-libs/gstreamer:${SLOT}
"
DEPEND="
	>=sys-apps/sed-4
	virtual/pkgconfig
"

if [[ ${PN} != ${GST_ORG_MODULE} ]]; then
	# Do not run test phase for invididual plugin ebuilds.
	RESTRICT="test"
	RDEPEND="${RDEPEND} >=media-libs/${GST_ORG_MODULE}-${PV}:${SLOT}"
else
	IUSE="nls"
	DEPEND="${DEPEND} nls? ( >=sys-devel/gettext-0.17 )"
fi

#if [[ ${SLOT} == "0.10" ]]; then
# XXX: verify with old ebuilds.
# DEPEND="${DEPEND} dev-libs/liboil"
#fi

DEPEND="${DEPEND} ${RDEPEND}"

# @FUNCTION: gst-plugins10_get_plugins
# @INTERNAL
# @DESCRIPTION:
# Get the list of plugins requiring external dependencies.
gst-plugins10_get_plugins() {
	# Must be called from src_prepare/src_configure
	GST_PLUGINS_LIST=$(sed -rn 's/^AG_GST_CHECK_FEATURE\((\w+),.*/ \1 /p' \
		"${S}"/configure.* | LC_ALL='C' tr '[:upper:]' '[:lower:]')
}

# @FUNCTION: gst-plugins10_find_plugin_dir
# @USAGE: gst-plugins10_find_plugin_dir [<build_dir>]
# @INTERNAL
# @DESCRIPTION:
# Finds plugin build directory and cd to it.
# Defaults to ${GST_PLUGINS_BUILD_DIR} if argument is not provided
gst-plugins10_find_plugin_dir() {
	local build_dir=${1:-${GST_PLUGINS_BUILD_DIR}}

	if [[ ! -d ${S}/ext/${build_dir} ]]; then
		if [[ ! -d ${S}/sys/${build_dir} ]]; then
			ewarn "No such plugin directory"
			die
		fi
		einfo "Building system plugin in ${build_dir}..."
		cd "${S}"/sys/${build_dir}
	else
		einfo "Building external plugin in ${build_dir}..."
		cd "${S}"/ext/${build_dir}
	fi
}

# @FUNCTION: gst-plugins10_system_link
# @USAGE: gst-plugins10_system_link gst-libs/gst/audio:gstreamer-audio [...]
# @DESCRIPTION:
# Walks through makefiles in order to make sure build will link against system
# librairies.
# Takes a list of path fragments and corresponding pkgconfig libraries
# separated by colon (:). Will replace the path fragment by the output of
# pkgconfig.
gst-plugins10_system_link() {
	local directory libs pkgconfig pc tuple
	pkgconfig=$(tc-getPKG_CONFIG)

	for plugin_dir in ${GST_PLUGINS_BUILD_DIR} ; do
		gst-plugins10_find_plugin_dir ${plugin_dir}

		for tuple in $@ ; do
			directory="$(echo ${tuple} | cut -f1 -d':')"
			pc="$(echo ${tuple} | cut -f2 -d':')-${SLOT}"
			libs="$(${pkgconfig} --libs-only-l ${pc})"
			sed -e "s:\$(top_builddir)/${directory}/.*\.la:${libs}:" \
				-i Makefile.am Makefile.in || die
		done
	done
}

# @FUNCTION: gst-plugins10_remove_unversioned_binaries
# @INTERNAL
# @DESCRIPTION:
# Remove the unversioned binaries gstreamer provides to prevent file collision
# with other slots. DEPRECATED
gst-plugins10_remove_unversioned_binaries() {
	cd "${D}"/usr/bin
	local gst_bins
	for gst_bins in *-${SLOT} ; do
		[[ -e ${gst_bins} ]] || continue
		rm ${gst_bins/-${SLOT}/}
		einfo "Removed ${gst_bins/-${SLOT}/}"
	done
}

# @FUNCTION: gst-plugins10_src_configure
# @DESCRIPTION:
# Handles logic common to configuring gstreamer plugins
gst-plugins10_src_configure() {
	local plugin gst_conf

	if has ${EAPI:-0} 0 1 2 3 ; then
		gst_conf="${gst_conf} --disable-dependency-tracking"
	fi

	if has ${EAPI:-0} 0 1 2 3 4 ; then
		gst_conf="${gst_conf} --disable-silent-rules"
	fi

	gst-plugins10_get_plugins

	for plugin in ${GST_PLUGINS_LIST} ; do
		if has ${plugin} ${GST_PLUGINS_BUILD} ; then
			gst_conf="${gst_conf} --enable-${plugin}"
		else
			gst_conf="${gst_conf} --disable-${plugin}"
		fi
	done

	if grep -q "ORC_CHECK" configure.* ; then
		if in_iuse orc ; then
			gst_conf="${gst_conf} $(use_enable orc)"
		else
			gst_conf="${gst_conf} --disable-orc"
		fi
	fi

	if grep -q "AM_MAINTAINER_MODE" configure.* ; then
		gst_conf="${gst_conf} --disable-maintainer-mode"
	fi

	if grep -q "disable-schemas-compile" configure ; then
		gst_conf="${gst_conf} --disable-schemas-compile"
	fi

	if [[ ${PN} == ${GST_ORG_MODULE} ]]; then
		gst_conf="${gst_conf} $(use_enable nls)"
	fi

	einfo "Configuring to build ${GST_PLUGINS_BUILD} plugin(s) ..."
	econf \
		--with-package-name="Gentoo GStreamer ebuild" \
		--with-package-origin="http://www.gentoo.org" \
		${gst_conf} $@
}

# @FUNCTION: gst-plugins10_src_compile
# @DESCRIPTION:
# Compiles requested gstreamer plugin.
gst-plugins10_src_compile() {
	local plugin_dir
	
	has ${EAPI:-0} 0 1 && gst-plugins10_src_configure "$@"

	for plugin_dir in ${GST_PLUGINS_BUILD_DIR} ; do
		gst-plugins10_find_plugin_dir ${plugin_dir}

		if has "${EAPI:-0}" 0 1 2 3 ; then
			emake || die
		else
			default
		fi
	done
}

# @FUNCTION: gst-plugins10_src_install
# @DESCRIPTION:
# Installs requested gstreamer plugin.
gst-plugins10_src_install() {
	local plugin_dir
	
	for plugin_dir in ${GST_PLUGINS_BUILD_DIR} ; do
		gst-plugins10_find_plugin_dir ${plugin_dir}

		if has "${EAPI:-0}" 0 1 2 3 ; then
			emake install DESTDIR="${D}" || die
			[[ -e README ]] && dodoc README
		else
			default
		fi
	done

	[[ ${GST_LA_PUNT} = "yes" ]] && prune_libtool_files --modules
}

