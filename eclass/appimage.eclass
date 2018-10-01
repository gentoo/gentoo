# Copyright 2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: appimage.eclass
# @MAINTAINER:
# maintainer-wanted@gentoo.org
# @AUTHOR:
# Mykyta Holubakha <hilobakho@gmail.com>
# @BLURB: convenience eclass for extracting AppImage bundles
# @DESCRIPTION:
# This eclass provides a src_unpack function to extract AppImage bundles

case "${EAPI:-0}" in
	6|7)
		;;
	*)
		die "EAPI ${EAPI:-0} is not supported"
		;;
esac

EXPORT_FUNCTIONS src_unpack

# @VARIABLE: APPIMAGE_EXTRACT_DIR
# @DEFAULT_UNSET: squashfs_root
# @DESCRIPTION:
# This variable specifies the directory, in which the AppImage bundle
# is expected to be extracted.

# @VARIABLE: APPIMAGE_EXTRACT_DEST
# @DEFAULT_UNSET: ${P}
# @DESCRIPTION:
# This variable specifies the directory, to which the extracted image
# will be moved.

# @FUNCTION: appimage_src_unpack
# @DESCRIPTION:
# Unpack all the AppImage bundles from ${A} (with .appimage extension).
# Other files are passed to regular unpack.
appimage_src_unpack() {
	debug-print-function ${FUNCNAME} "${@}"

	local extract_dir="${APPIMAGE_EXTRACT_DIR:-squashfs-root}"
	local extract_dest="${APPIMAGE_EXTRACT_DEST:-${P}}"

	local f
	for f in ${A}
	do
		case "${f}" in
			*.appimage|*.AppImage)
				cp "${DISTDIR}/${f}" "${WORKDIR}"
				debug-print "${FUNCNAME}: unpacking bundle ${f} to ${extract_dest}"
				chmod +x "${f}" \
					|| die "Failed to add execute permissions to bundle"
				"${WORKDIR}/${f}" --appimage-help >/dev/null 2>/dev/null \
					|| die "Invalid AppImage bundle"
				"${WORKDIR}/${f}" --appimage-extract >/dev/null 2>/dev/null \
					|| die "Failed to extract AppImage bundle"
				rm -f "${f}" || die "Failed to remove bundle copy"
				mv "${extract_dir}" "${extract_dest}" \
					|| die "Failed to move AppImage bundle to destination"
				;;
			*)
				debug-print "${FUNCNAME}: falling back to unpack for ${f}"
				unpack "${f}"
				;;
		esac
	done
}

