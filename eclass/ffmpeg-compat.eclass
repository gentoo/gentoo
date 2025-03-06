# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ffmpeg-compat.eclass
# @MAINTAINER:
# Ionen Wolkens <ionen@gentoo.org>
# @AUTHOR:
# Ionen Wolkens <ionen@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @BLURB: Helper functions to link with slotted ffmpeg-compat libraries
# @DESCRIPTION:
# To use this, run ``ffmpeg_compat_setup <slot>`` before packages use
# pkg-config, depend on media-video/ffmpeg-compat:<slot>=, and ensure
# usage of both pkg-config --cflags and --libs (which adds -Wl,-rpath
# to find libraries at runtime).
#
# This eclass is intended as a quick-to-setup alternative to setting
# an upper bound on ffmpeg for packages broken with the latest version,
# and thus allow users to upgrade their normal ffmpeg.
#
# This should still be a temporary measure, and it is recommended to
# keep migration bugs open rather than consider this eclass as being
# the "fix".
#
# Unlike LLVM_SLOT-style, this does not have USE to select the slot
# and should instead pick only the highest one usable until package
# is fixed and can use non-slotted ffmpeg again.
#
# Do *not* use both like ``|| ( <ffmpeg-<ver> ffmpeg-compat:<slot> )``,
# the package manager cannot know which version it linked against
# without USE flags.  Unfortunately means a period where users may
# have two identical versions in stable before the newest major version
# is stabilized, but idea is to not mangle normal ffmpeg with slotting
# logic and make this an isolated temporary deal.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_FFMPEG_COMPAT_ECLASS} ]]; then
_FFMPEG_COMPAT_ECLASS=1

# @FUNCTION: ffmpeg_compat_get_prefix
# @USAGE: <slot>
# @DESCRIPTION:
# Return prefix of the installed ffmpeg-compat:<slot>.  Binaries like
# ffmpeg will be found under <prefix>/bin if needed.
ffmpeg_compat_get_prefix() {
	(( ${#} == 1 )) || die "Usage: ${FUNCNAME} <slot>"

	echo "${EPREFIX}/usr/lib/ffmpeg${1}"
}

# @FUNCTION: ffmpeg_compat_setup
# @USAGE: <slot>
# @DESCRIPTION:
# Add ESYSROOT's ffmpeg-compat:<slot> to PKG_CONFIG_PATH for the
# current ABI.
ffmpeg_compat_setup() {
	(( ${#} == 1 )) || die "Usage: ${FUNCNAME} <slot>"

	: "${SYSROOT}$(ffmpeg_compat_get_prefix "${1}")/$(get_libdir)/pkgconfig"
	export PKG_CONFIG_PATH=${_}:${PKG_CONFIG_PATH}
}

fi
