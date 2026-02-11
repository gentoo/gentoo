# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

MY_PV_HIGH=$(ver_cut 1)
MY_PV_MIDDLE=$(ver_cut 2)
MY_PV_LOW=$(ver_cut 3)

MY_PV="${MY_PV_HIGH}.${MY_PV_MIDDLE}-${MY_PV_LOW}"
MY_PN="amf-amdgpu-pro"
MY_PN_ENC="libamdenc-amdgpu-pro"
AMF_HEADERS_VER="1.5.0"

UBUNTU_VER="noble"

DESCRIPTION="AMD's closed source Advanced Media Framework (AMF) driver for AMD GPUs"
HOMEPAGE="https://www.amd.com/en/support"

URI_PREFIX="repo.radeon.com/amf/${MY_PV_HIGH}.${MY_PV_MIDDLE}/ubuntu/pool/main/${UBUNTU_VER}/"

SRC_URI="
	https://${URI_PREFIX}/${MY_PN}_${MY_PV}_amd64.deb -> ${P}.deb
	https://${URI_PREFIX}/${MY_PN_ENC}_${MY_PV}_amd64.deb -> ${P}-enc.deb
"

S="${WORKDIR}"

LICENSE="AMD-GPU-PRO-EULA"
SLOT="0"
KEYWORDS="-* amd64"

IUSE="video_cards_amdgpu"
REQUIRED_USE="
	video_cards_amdgpu
"

RESTRICT="bindist mirror"

RDEPEND="
	x11-libs/libdrm
	media-libs/mesa[proprietary-codecs,vulkan]
"

QA_PREBUILT="
	usr/lib64/libamfrt64.so*
	usr/lib64/libamdenc64.so*
"

src_unpack() {
	unpack_deb "${DISTDIR}/${P}.deb"
	unpack_deb "${DISTDIR}/${P}-enc.deb"
}

src_install() {
	insinto "/usr/$(get_libdir)"

	doins "${S}/opt/amf/lib/x86_64-linux-gnu/libamfrt64.so.${AMF_HEADERS_VER}"
	dosym "libamfrt64.so.${AMF_HEADERS_VER}" "/usr/$(get_libdir)/libamfrt64.so.1"
	dosym "libamfrt64.so.1" "/usr/$(get_libdir)/libamfrt64.so"

	doins "${S}/opt/amf/lib/x86_64-linux-gnu/libamdenc64.so.1.0"
	doins "${S}/opt/amf/lib/x86_64-linux-gnu/libamdenc64.so"
}
