# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

MY_PV_HIGH=$(ver_cut 1)
MY_PV_MIDDLE=$(ver_cut 2)
MY_PV_LOW=$(ver_cut 3)
MY_PV_REV=$(ver_cut 4)

MY_PV="${MY_PV_HIGH}.${MY_PV_MIDDLE}"

MY_PV_LINK="$MY_PV"
[[ $MY_PV_LOW != "0" ]] && MY_PV_LINK+=".$MY_PV_LOW"

MY_PV_FULL="${MY_PV}-${MY_PV_REV}"

MY_PN="vulkan-amdgpu-pro"

MY_LINK="https://repo.radeon.com/amdgpu/${MY_PV_LINK}/ubuntu/pool/proprietary/v/${MY_PN}"

UBUNTU_VER="22.04"

DESCRIPTION="AMD's closed source vulkan driver, from Radeon Software for Linux"
HOMEPAGE="https://www.amd.com/en/support"
SRC_URI="
	abi_x86_64? ( ${MY_LINK}/${MY_PN}_${MY_PV_FULL}~${UBUNTU_VER}_amd64.deb -> ${P}-amd64.deb )
	abi_x86_32? ( ${MY_LINK}/${MY_PN}_${MY_PV_FULL}~${UBUNTU_VER}_i386.deb -> ${P}-i386.deb )
"
S="${WORKDIR}"

RESTRICT="bindist mirror"

LICENSE="AMD-GPU-PRO-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="abi_x86_32 abi_x86_64 video_cards_amdgpu"

REQUIRED_USE="video_cards_amdgpu"

BDEPEND="dev-util/patchelf"

QA_PREBUILT="
	usr/lib64/amdvlkpro64.so*
	usr/lib/amdvlkpro32.so*
"

src_unpack() {
	if use abi_x86_64 ; then
		mkdir "${S}/${PN}-amd64" || die
		cd "${S}/${PN}-amd64" || die
		unpack_deb "${DISTDIR}/${P}-amd64.deb"
	fi

	if use abi_x86_32 ; then
		mkdir "${S}/${PN}-i386" || die
		cd "${S}/${PN}-i386" || die
		unpack_deb "${DISTDIR}/${P}-i386.deb"
	fi
}

src_prepare() {
	if use abi_x86_64 ; then
		cd "${S}/${PN}-amd64/opt/amdgpu-pro/lib/x86_64-linux-gnu/" || die

		# Make sure there's only one file in the folder, to prevent unexpected behavior of the next command
		[[ "$(ls | wc -l)" = '1' ]] || die "more than one file in opt/amdgpu-pro/lib/x86_64-linux-gnu/"

		# Add "pro" in the .so file's name, and remove any numeric extension "e.g. amdvlk64.so.1"
		mv amdvlk64.so* amdvlkpro64.so || die

		# same with the SONAME
		patchelf --set-soname amdvlkpro64.so "${PWD}"/amdvlkpro64.so || die

		cd "${S}/${PN}-amd64/opt/amdgpu-pro/etc/vulkan/icd.d/" || die
		eapply "${FILESDIR}"/icd_amd64.patch
		mv amd_icd64.json amd_pro_icd64.json || die
	fi

	if use abi_x86_32 ; then
		cd "${S}/${PN}-i386/opt/amdgpu-pro/lib/i386-linux-gnu/" || die

		# Make sure there's only one file in the folder, to prevent unexpected behavior of the next command
		[[ "$(ls | wc -l)" = '1' ]] || die "more than one file in opt/amdgpu-pro/lib/i386-linux-gnu/"

		# Add "pro" in the .so file's name, and remove any numeric extension "e.g. amdvlk32.so.1"
		mv amdvlk32.so* amdvlkpro32.so || die

		# same with the SONAME
		patchelf --set-soname amdvlkpro32.so "${PWD}"/amdvlkpro32.so || die

		cd "${S}/${PN}-i386/opt/amdgpu-pro/etc/vulkan/icd.d/" || die
		eapply "${FILESDIR}"/icd_x86.patch
		mv amd_icd32.json amd_pro_icd32.json || die
	fi

	default
}

src_install() {
	if use abi_x86_64 ; then
		# Vulkan driver
		insinto /usr/lib64
		doins "${S}"/"${PN}"-amd64/opt/amdgpu-pro/lib/x86_64-linux-gnu/amdvlkpro64.so

		# ICD loader
		insinto /usr/share/vulkan/icd.d
		doins "${S}"/"${PN}"-amd64/opt/amdgpu-pro/etc/vulkan/icd.d/amd_pro_icd64.json
	fi

	if use abi_x86_32 ; then
		# Vulkan driver
		insinto /usr/lib
		doins "${S}"/"${PN}"-i386/opt/amdgpu-pro/lib/i386-linux-gnu/amdvlkpro32.so

		# ICD loader
		insinto /usr/share/vulkan/icd.d
		doins "${S}"/"${PN}"-i386/opt/amdgpu-pro/etc/vulkan/icd.d/amd_pro_icd32.json
	fi
}

pkg_postinst() {

	if use abi_x86_32; then
		elog "To run a 32bit program using the amdgpu-pro vulkan driver, the environment variable"
		elog "     VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/amd_pro_icd32.json"
		elog "must be set beforehand"
		elog
	fi

	if use abi_x86_64; then
		elog "To run a 64bit program using the amdgpu-pro vulkan driver, the environment variable"
		elog "     VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/amd_pro_icd64.json"
		elog "must be set beforehand"
	fi
}
