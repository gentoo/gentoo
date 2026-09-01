# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

MY_PV_REV=$(ver_cut 3)

MY_PN="amf-amdgpu-pro"
MY_PN_ENC="libamdenc-amdgpu-pro"

INTERNAL_VER="6.4.4"
EXTERNAL_VER="25.10"
UBUNTU_VER="24.04"
AMF_HEADERS_VER="1.4.37"

DESCRIPTION="AMD's closed source GPU video encode/decode binary driver, for RDNA2 or older"
HOMEPAGE="https://www.amd.com/en/support"

URI_PREFIX="repo.radeon.com/amdgpu/${INTERNAL_VER}/ubuntu/pool/proprietary"

SRC_URI="
	https://${URI_PREFIX}/a/${MY_PN}/${MY_PN}_${AMF_HEADERS_VER}-${MY_PV_REV}.${UBUNTU_VER}_amd64.deb -> ${P}.deb
	https://${URI_PREFIX}/liba/${MY_PN_ENC}/${MY_PN_ENC}_${EXTERNAL_VER}-${MY_PV_REV}.${UBUNTU_VER}_amd64.deb -> ${P}-enc.deb
"

S="${WORKDIR}/${PN}-amd64"

LICENSE="AMD-GPU-PRO-EULA"
SLOT="legacy"
KEYWORDS="-* amd64"

# Version 25.10 is the last one that supports GPUs older or equal to RDNA2
# https://github.com/GPUOpen-LibrariesAndSDKs/AMF/issues/575

IUSE="pro +radv video_cards_amdgpu"
REQUIRED_USE="
	video_cards_amdgpu
	|| ( radv  pro )
"

RESTRICT="bindist mirror"

RDEPEND="
	x11-libs/libdrm
	pro? ( media-libs/amdgpu-pro-vulkan )
	radv? ( media-libs/mesa[proprietary-codecs,vulkan] )
"

QA_PREBUILT="
	usr/lib64/libamfrt64.so*
	usr/lib64/libamdenc64.so*
"

src_unpack() {
	mkdir -p "${S}" || die
	cd "${S}" || die
	unpack_deb "${DISTDIR}/${P}.deb"
	unpack_deb "${DISTDIR}/${P}-enc.deb"
}

src_install() {
	insinto "/usr/$(get_libdir)"

	doins "${S}/opt/amdgpu-pro/lib/x86_64-linux-gnu/libamfrt64.so.${AMF_HEADERS_VER}"
	dosym "libamfrt64.so.${AMF_HEADERS_VER}" "/usr/$(get_libdir)/libamfrt64.so.1"
	dosym "libamfrt64.so.1" "/usr/$(get_libdir)/libamfrt64.so"

	doins "${S}/opt/amdgpu-pro/lib/x86_64-linux-gnu/libamdenc64.so.1.0"
	doins "${S}/opt/amdgpu-pro/lib/x86_64-linux-gnu/libamdenc64.so"
}
