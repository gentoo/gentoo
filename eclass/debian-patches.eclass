# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: debian-patches.eclass
# @MAINTAINER:
# Sam James <sam@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @BLURB: Convenience eclass for easily using Debian patchsets as upstream
# @DESCRIPTION:
# Allows easily using Debian as upstream either for patches standalone or
# additionally sources by setting SRC_URI and S.
# It also handles application of patches cleanly with pretty output. PATCHES
# defined in the ebuild will be applied after any Debian patches.

# @ECLASS_VARIABLE: DEBIAN_PN
# @PRE_INHERIT
# @DESCRIPTION:
# Debian name for the package. Defaults to ${PN}.
: ${DEBIAN_PN:=${PN}}

# @ECLASS_VARIABLE: DEBIAN_PV
# @PRE_INHERIT
# @DESCRIPTION:
# Debian patch level. Defaults to ${PV#*_p}.
: ${DEBIAN_PV:=${PV#*_p}}

# @ECLASS_VARIABLE: DEBIAN_ORIG
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# Controls whether the "original" upstream sources (unpatched) are fetched
# from Debian or not. Defaults to no.

# @ECLASS_VARIABLE: DEBIAN_ORIG_PV
# @PRE_INHERIT
# @DESCRIPTION:
# Controls the PV used without the patchlevel. Defaults to ${PV/_p*}.
: ${DEBIAN_ORIG_PV:=${PV/_p*}}

# @ECLASS_VARIABLE: DEBIAN_ORIG_SUFFIX
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# Controls the Debian "original" upstream sources (unpatched) file suffix.
# Defaults to gz.
: ${DEBIAN_ORIG_SUFFIX:=gz}

# @ECLASS_VARIABLE: DEBIAN_SKIP_PATCHES
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of patches to skip when applying the Debian patchset from debian/patches
# within the sources.

if [[ -n ${DEBIAN_ORIG} ]] ; then
	SRC_URI+=" mirror://debian/pool/main/${DEBIAN_PN::1}/${DEBIAN_PN}/${DEBIAN_PN}_${DEBIAN_ORIG_PV}.orig.tar.${DEBIAN_ORIG_SUFFIX}"
	S="${WORKDIR}"/${DEBIAN_PN}-${DEBIAN_ORIG_PV}
fi

SRC_URI+=" mirror://debian/pool/main/${DEBIAN_PN::1}/${DEBIAN_PN}/${DEBIAN_PN}_${DEBIAN_ORIG_PV}-${DEBIAN_PV}.debian.tar.xz"

# @FUNCTION: debian-patches_src_prepare
# @DESCRIPTION:
# Prepares the sources by applying patches from debian/patches within
# the sources using pretty output.
debian-patches_src_prepare() {
	local debian_patches_dir="${WORKDIR}"/debian/patches

	# Always parse the series file because not all Debian patches are
	# (exclusively) numbered.
	if [[ -f "${debian_patches_dir}"/series ]] ; then
		local skip_patch
		for skip_patch in "${DEBIAN_SKIP_PATCHES[@]}" ; do
			sed -i -e "/^${skip_patch}$/d" "${debian_patches_dir}"/series || die
			rm "${debian_patches_dir}"/${skip_patch} || die
		done

		local debian_patch_list
		readarray -t debian_patch_list < "${debian_patches_dir}"/series

		mv "${debian_patches_dir}" "${debian_patches_dir}.orig" || die
		mkdir "${T}"/debian_eclass_sorted || die

		# We want to get the nice eapply output when it's given a directory,
		# as it clearly delinates what the external patches are, so
		# we rename the patches into an order eapply will Just Work with.
		local patch patch_index=0
		for patch in "${debian_patch_list[@]}"; do
			local new_patch_num=$(printf "%04d" $(( patch_index++ )))

			mv "${debian_patches_dir}.orig"/${patch} "${T}"/debian_eclass_sorted/${new_patch_num}-${patch} || die
		done

		# We use a temporary dir and then rename for the sorted patches
		# so the eapply output is nicer - and matches convention before
		# debian.eclass.
		mv "${T}"/debian_eclass_sorted "${debian_patches_dir}" || die
		eapply "${debian_patches_dir}"
	fi

	default
}

EXPORT_FUNCTIONS src_prepare
