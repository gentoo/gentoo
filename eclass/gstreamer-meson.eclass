# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gstreamer-meson.eclass
# @MAINTAINER:
# gstreamer@gentoo.org
# @AUTHOR:
# Haelwenn (lanodan) Monnier <contact@hacktivis.me>
# Michał Górny <mgorny@gentoo.org>
# Gilles Dartiguelongue <eva@gentoo.org>
# Saleem Abdulrasool <compnerd@gentoo.org>
# foser <foser@gentoo.org>
# zaheerm <zaheerm@gentoo.org>
# Steven Newbury
# @SUPPORTED_EAPIS: 7
# @PROVIDES: meson multilib-minimal
# @BLURB: Helps building core & split gstreamer plugins
# @DESCRIPTION:
# Eclass to make external ``gst-plugins`` emergable on a per-plugin basis
# and to solve the problem with ``gst-plugins`` generating far too much
# unneeded dependencies.
#
# GStreamer consuming applications should depend on the specific plugins
# they need as defined in their source code. Usually you can find that
# out by grepping the source tree for ``factory_make``. If it uses ``playbin``
# plugin, consider adding ``media-plugins/gst-plugins-meta`` dependency, but
# also list any packages that provide explicitly requested plugins.

# multilib-minimal goes last
inherit meson multilib toolchain-funcs virtualx xdg-utils multilib-minimal

case "${EAPI:-0}" in
	7)
		;;
	*)
		die "EAPI=\"${EAPI}\" is not supported"
		;;
esac

# @ECLASS_VARIABLE: GST_PLUGINS_ENABLED
# @DESCRIPTION:
# Defines the plugins to be built.
# May be set by an ebuild and contain more than one identifier, space
# separated (only ``src_configure`` can handle multiple plugins at this time).

# @ECLASS_VARIABLE: GST_PLUGINS_NOAUTO
# @DESCRIPTION:
# Space-separated list defined by the ebuild for plugin options which shouldn't
# be automatically defined by ``gstreamer_multilib_src_configure``.

# @FUNCTION: gstreamer_get_default_enabled_plugins
# @INTERNAL
# @DESCRIPTION:
# Get the list of plugins to be built by default, meaning the ones with no
# external dependencies for base packages and the name of the package for
# split ones.
gstreamer_get_default_enabled_plugins() {
	if [[ "${GST_ORG_MODULE}" == "${PN}" ]]; then
		gstreamer_get_plugins
		echo "${GST_PLUGINS_NO_EXT_DEPS}" | tr '\n' ' '
	else
		echo "${PN/gst-plugins-/}"
	fi
}

# @FUNCTION: gstreamer_get_plugins
# @INTERNAL
# @DESCRIPTION:
# Get the list of all plugins, with and without external dependencies.
# Must be called from src_prepare/src_configure
gstreamer_get_plugins() {
	GST_PLUGINS_NO_EXT_DEPS=$(sed -rn \
		"/^# Feature options for plugins with(out| no) external deps$/,/^#.*$/s;^option\('([^']*)'.*;\1;p" \
		"${S}/meson_options.txt" || die "Failed to extract options for plugins without external deps"
	)

	GST_PLUGINS_EXT_DEPS=$(sed -rn \
		"/^# Feature options for plugins (with|that need) external deps$/,/^#.*$/s;^option\('([^']*)'.*;\1;p" \
		"${S}/meson_options.txt" || die "Failed to extract options for plugins with external deps"
	)

	# opencv and hls in gst-plugins-bad are split, can't be properly detected
	if grep -q "option('opencv'" "${EMESON_SOURCE}"/meson_options.txt ; then
		GST_PLUGINS_EXT_DEPS="${GST_PLUGINS_EXT_DEPS}
opencv"
	fi
	if grep -q "option('hls'" "${EMESON_SOURCE}"/meson_options.txt ; then
		GST_PLUGINS_EXT_DEPS="${GST_PLUGINS_EXT_DEPS}
hls"
	fi
}

# @FUNCTION: gstreamer_system_package
# @USAGE: <gstaudio_dep:gstreamer-audio> [...]
# @DESCRIPTION:
# Walks through meson.build in order to make sure build will link against system
# libraries.
#
# Takes a list of path fragments and corresponding ``pkgconfig`` libraries
# separated by colon (``:``). Will replace the path fragment by the output of
# ``pkgconfig``.
gstreamer_system_package() {
	local pdir directory libs pkgconfig pc tuple plugin_dir
	pkgconfig=$(tc-getPKG_CONFIG)

	for plugin_dir in ${GST_PLUGINS_BUILD_DIR} ; do
		pdir=$(gstreamer_get_plugin_dir ${plugin_dir})

		for tuple in $@ ; do
			dependency=${tuple%:*}
			pc=${tuple#*:}-${SLOT}
			sed -e "1i${dependency} = dependency('${pc}', required : true)" \
				-i "${pdir}"/meson.build || die
		done
	done
}

# @FUNCTION: gstreamer_system_library
# @USAGE: <gstbasecamerabin_dep:libgstbasecamerabinsrc> [...]
# @DESCRIPTION:
# Walks through ``meson.build`` in order to make sure build will link against
# system libraries.
#
# Takes a list of path fragments and corresponding ``pkgconfig`` libraries
# separated by colon (``:``). Will replace the path fragment by the output of
# ``pkgconfig``.
gstreamer_system_library() {
	local pdir directory libs pkgconfig pc tuple plugin_dir
	pkgconfig=$(tc-getPKG_CONFIG)

	for plugin_dir in ${GST_PLUGINS_BUILD_DIR} ; do
		pdir=$(gstreamer_get_plugin_dir ${plugin_dir})

		for tuple in $@ ; do
			dependency=${tuple%:*}
			pc=${tuple#*:}-${SLOT}
			sed -e "1i${dependency} = cc.find_library('${pc}', required : true)" \
				-i "${pdir}"/meson.build || die
		done
	done
}

# @ECLASS_VARIABLE: GST_PLUGINS_BUILD_DIR
# @DESCRIPTION:
# Actual build directories of the plugins.
# Most often the same as the configure switch name.
#
# *FIXME*: Change into a bash array
: ${GST_PLUGINS_BUILD_DIR:=${PN/gst-plugins-/}}

# @ECLASS_VARIABLE: GST_TARBALL_SUFFIX
# @DESCRIPTION:
# Most projects hosted on https://gstreamer.freedesktop.org mirrors provide
# tarballs as ``tar.bz2`` or ``tar.xz``. This eclass defaults to ``xz``. This
# is because the gstreamer mirrors are moving to only have ``xz`` tarballs for
# new releases.
: ${GST_TARBALL_SUFFIX:="xz"}

# Even though xz-utils are in @system, they must still be added to BDEPEND; see
# https://archives.gentoo.org/gentoo-dev/msg_a0d4833eb314d1be5d5802a3b710e0a4.xml
if [[ ${GST_TARBALL_SUFFIX} == "xz" ]]; then
	BDEPEND="${BDEPEND} app-arch/xz-utils"
fi

# @ECLASS_VARIABLE: GST_ORG_MODULE
# @DESCRIPTION:
# Name of the module as hosted on https://gstreamer.freedesktop.org mirrors.
# Leave unset if package name matches module name.
: ${GST_ORG_MODULE:=${PN}}

# @ECLASS_VARIABLE: GST_ORG_PVP
# @INTERNAL
# @DESCRIPTION:
# Major and minor numbers of the version number.
: ${GST_ORG_PVP:=$(ver_cut 1-2)}


DESCRIPTION="${BUILD_GST_PLUGINS} plugin for gstreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://gstreamer.freedesktop.org/src/${GST_ORG_MODULE}/${GST_ORG_MODULE}-${PV}.tar.${GST_TARBALL_SUFFIX}"
S="${WORKDIR}/${GST_ORG_MODULE}-${PV}"

LICENSE="GPL-2"
SLOT="1.0"

RDEPEND="
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
"
BDEPEND="
	>=sys-apps/sed-4
	virtual/pkgconfig
	virtual/perl-JSON-PP
"

if [[ "${PN}" != "gstreamer" ]]; then
	RDEPEND="
		${RDEPEND}
		>=media-libs/gstreamer-$(ver_cut 1-2):${SLOT}[${MULTILIB_USEDEP}]
	"
fi

# Export common multilib phases.
multilib_src_configure() { gstreamer_multilib_src_configure; }
multilib_src_compile() { gstreamer_multilib_src_compile; }
multilib_src_install() { gstreamer_multilib_src_install; }

if [[ "${PN}" != "${GST_ORG_MODULE}" ]]; then
	# Do not run test phase for individual plugin ebuilds.
	RESTRICT="test"
	RDEPEND="${RDEPEND}
		>=media-libs/${GST_ORG_MODULE}-${PV}:${SLOT}[${MULTILIB_USEDEP}]"

	# Export multilib phases used for split builds.
	multilib_src_install_all() { gstreamer_multilib_src_install_all; }
else
	local extra_deps=""

	IUSE="nls test"
	RESTRICT="!test? ( test )"
	if [[ "${PN}" != "gstreamer" ]]; then
		BDEPEND="${BDEPEND}
			nls? ( >=sys-devel/gettext-0.17 )
			test? ( media-libs/gstreamer[test] )
		"
	else
		BDEPEND="${BDEPEND}
			nls? ( >=sys-devel/gettext-0.17 )
		"
	fi

	multilib_src_test() { gstreamer_multilib_src_test; }
fi

DEPEND="${DEPEND} ${RDEPEND}"

# @FUNCTION: gstreamer_get_plugin_dir
# @USAGE: gstreamer_get_plugin_dir [<build_dir>]
# @INTERNAL
# @DESCRIPTION:
# Finds plugin build directory and output it.
# Defaults to ${GST_PLUGINS_BUILD_DIR} if argument is not provided
gstreamer_get_plugin_dir() {
	local build_dir=${1:-${GST_PLUGINS_BUILD_DIR}}

	if [[ ! -d ${S}/ext/${build_dir} ]]; then
		if [[ ! -d ${S}/sys/${build_dir} ]]; then
			ewarn "No such plugin directory"
			die
		fi
		einfo "Got system plugin in ${build_dir}..." >&2
		echo sys/${build_dir}
	else
		einfo "Got external plugin in ${build_dir}..." >&2
		echo ext/${build_dir}
	fi
}

# @VARIABLE: GST_PLUGINS_ENOAUTO
# @INTERNAL
# @DESCRIPTION:
# Contains false-positives.
# - gst-plugins-bad puts "shm" in external deps
GST_PLUGINS_ENOAUTO="shm"

# @FUNCTION: gstreamer_multilib_src_configure
# @DESCRIPTION:
# Handles logic common to configuring gstreamer plugins
gstreamer_multilib_src_configure() {
	local plugin gst_conf=( ) EMESON_SOURCE=${EMESON_SOURCE:-${S}}

	gstreamer_get_plugins
	xdg_environment_reset

	GST_PLUGINS_ENABLED=${GST_PLUGINS_ENABLED:-$(gstreamer_get_default_enabled_plugins)}

	for plugin in ${GST_PLUGINS_NO_EXT_DEPS} ${GST_PLUGINS_EXT_DEPS} ; do
		if has ${plugin} ${GST_PLUGINS_NOAUTO} ${GST_PLUGINS_ENOAUTO}; then
			: # noop
		elif has ${plugin} ${GST_PLUGINS_ENABLED} ; then
			gst_conf+=( -D${plugin}=enabled )
		else
			gst_conf+=( -D${plugin}=disabled )
		fi
	done

	if grep -q "option('orc'" "${EMESON_SOURCE}"/meson_options.txt ; then
		if in_iuse orc ; then
			gst_conf+=( -Dorc=$(usex orc enabled disabled) )
		else
			gst_conf+=( -Dorc=disabled )
			eqawarn "QA: IUSE=orc is missing while plugin supports it"
		fi
	else
		if in_iuse orc ; then
			eqawarn "QA: IUSE=orc is present while plugin does not support it"
		fi
	fi

	if grep -q "option('introspection'" "${EMESON_SOURCE}"/meson_options.txt ; then
		if in_iuse introspection ; then
			gst_conf+=( -Dintrospection=$(multilib_native_usex introspection enabled disabled) )
		else
			gst_conf+=( -Dintrospection=disabled )
			eqawarn "QA: IUSE=introspection is missing while plugin supports it"
		fi
	else
		if in_iuse introspection ; then
			eqawarn "QA: IUSE=introspection is present while plugin does not support it"
		fi
	fi

	if grep -q "option('maintainer-mode'" "${EMESON_SOURCE}"/meson_options.txt ; then
		gst_conf+=( -Dmaintainer-mode=disabled )
	fi

	if grep -q "option('schemas-compile'" "${EMESON_SOURCE}"/meson_options.txt ; then
		gst_conf+=( -Dschemas-compile=disabled )
	fi

	if grep -q "option('examples'" "${EMESON_SOURCE}"/meson_options.txt ; then
		gst_conf+=( -Dexamples=disabled )
	fi

	if [[ ${PN} == ${GST_ORG_MODULE} ]]; then
		if grep -q "option('nls'" "${EMESON_SOURCE}"/meson_options.txt ; then
			gst_conf+=( $(meson_feature nls) )
		fi

		if grep -q "option('tests'" "${EMESON_SOURCE}"/meson_options.txt ; then
			gst_conf+=( $(meson_feature test tests) )
		fi
	fi

	if grep -qF "option('package-name'" "${EMESON_SOURCE}"/meson_options.txt ; then
		gst_conf+=( -Dpackage-name="Gentoo GStreamer ebuild" )
	fi
	if grep -qF "option('package-origin'" "${EMESON_SOURCE}"/meson_options.txt ; then
		gst_conf+=( -Dpackage-origin="https://www.gentoo.org" )
	fi
	gst_conf+=( "${@}" )

	einfo "Configuring to build ${GST_PLUGINS_ENABLED} plugin(s) ..."
	meson_src_configure "${gst_conf[@]}"
}


# @FUNCTION: _gstreamer_get_target_filename
# @INTERNAL
# @DESCRIPTION:
# Looks for first argument being present as a substring in install targets
# Got ported from python to perl for greater language-stability
_gstreamer_get_target_filename() {
	cat >"${WORKDIR}/_gstreamer_get_target_filename.pl" <<"EOF"
#!/usr/bin/env perl
use strict;
use utf8;
use JSON::PP;

open(my $targets_file, '<:encoding(UTF-8)', 'meson-info/intro-targets.json') || die $!;
my $data = decode_json <$targets_file>;
close($targets_file) || die $!;

if(!$ARGV[0]) {
	die "Requires a target as argument";
}

foreach my $target (@{$data}) {
	if($target->{'installed'}
		and (index($target->{'filename'}[0], $ARGV[0]) != -1)
	) {
		printf "%s:%s\n", $target->{'filename'}[0], $target->{'install_filename'}[0];
	}
}
EOF

	chmod +x "${WORKDIR}/_gstreamer_get_target_filename.pl" || die

	perl "${WORKDIR}/_gstreamer_get_target_filename.pl" $@ \
		|| die "Failed to extract target filenames from meson-info"
}

# @FUNCTION: gstreamer_multilib_src_compile
# @DESCRIPTION:
# Compiles requested gstreamer plugin.
gstreamer_multilib_src_compile() {
	if [[ "${PN}" == "${GST_ORG_MODULE}" ]]; then
		eninja
	else
		local plugin_dir plugin build_dir

		for plugin_dir in ${GST_PLUGINS_BUILD_DIR} ; do
			plugin=$(_gstreamer_get_target_filename $(gstreamer_get_plugin_dir ${plugin_dir}))
			# Read full link of build directory. Outputs symlink's true link.
			# We want to get the full file path so it can be removed later.
			# Working around ninja issues w/ symlinks (e.g. PORTAGE_TMPDIR as a symlink)

			# https://github.com/ninja-build/ninja/issues/1251
			# https://github.com/ninja-build/ninja/issues/1330
			build_dir=$(readlink -f "${BUILD_DIR}")

			plugin_path="${plugin%%:*}"
			eninja "${plugin_path/"${build_dir}/"/}"
		done
	fi
}

# @FUNCTION: gstreamer_multilib_src_test
# @DESCRIPTION:
# Tests the gstreamer plugin (non-split)
gstreamer_multilib_src_test() {
	GST_GL_WINDOW=x11 virtx eninja test
}

# @FUNCTION: gstreamer_multilib_src_install
# @DESCRIPTION:
# Installs requested gstreamer plugin.
gstreamer_multilib_src_install() {
	if [[ "${PN}" == "${GST_ORG_MODULE}" ]]; then
		DESTDIR="${D}" eninja install
	else
		local plugin_dir plugin

		for plugin_dir in ${GST_PLUGINS_BUILD_DIR} ; do
			for plugin in $(_gstreamer_get_target_filename $(gstreamer_get_plugin_dir ${plugin_dir})); do
				local install_filename="${plugin##*:}"
				install_filename="${install_filename#${EPREFIX}}"
				insinto "${install_filename%/*}"
				doins "${plugin%%:*}"
			done
		done
	fi
}

# @FUNCTION: gstreamer_multilib_src_install_all
# @DESCRIPTION:
# Installs documentation for requested gstreamer plugin
gstreamer_multilib_src_install_all() {
	local plugin_dir

	for plugin_dir in ${GST_PLUGINS_BUILD_DIR} ; do
		local dir=$(gstreamer_get_plugin_dir ${plugin_dir})
		[[ -e ${dir}/README ]] && dodoc "${dir}"/README
	done
}
