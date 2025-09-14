# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

MY_PV_HIGH=$(ver_cut 1)
MY_PV_MIDDLE=$(ver_cut 2)
MY_PV_LOW=$(ver_cut 3)
MY_PV_REV=$(ver_cut 4)

MY_PV="${MY_PV_HIGH}.${MY_PV_MIDDLE}.${MY_PV_LOW}"
MY_PV_FULL="${MY_PV}-${MY_PV_REV}"

MY_PN="amf-amdgpu-pro"
MY_PN_ENC="libamdenc-amdgpu-pro"

INTERNAL_VER="6.3.4"
UBUNTU_VER="24.04"

DESCRIPTION="AMD's closed source Advanced Media Framework (AMF) driver for AMD GPUs"
HOMEPAGE="https://www.amd.com/en/support"

URI_PREFIX="repo.radeon.com/amdgpu/${INTERNAL_VER}/ubuntu/pool/proprietary"

SRC_URI="
	https://${URI_PREFIX}/a/${MY_PN}/${MY_PN}_${MY_PV_FULL}.${UBUNTU_VER}_amd64.deb -> ${P}.deb
	https://${URI_PREFIX}/liba/${MY_PN_ENC}/${MY_PN_ENC}_1.0-${MY_PV_REV}.${UBUNTU_VER}_amd64.deb -> ${P}-enc.deb
"

S="${WORKDIR}"

LICENSE="AMD-GPU-PRO-EULA"
SLOT="0"
KEYWORDS="-* amd64"

IUSE="+radv pro video_cards_amdgpu"
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
	mkdir "${S}/${PN}-amd64" || die
	cd "${S}/${PN}-amd64" || die
	unpack_deb "${DISTDIR}/${P}.deb"
	unpack_deb "${DISTDIR}/${P}-enc.deb"
}

src_install() {
	insinto "/usr/$(get_libdir)"

	doins "${S}/${PN}-amd64/opt/amdgpu-pro/lib/x86_64-linux-gnu/libamfrt64.so.${MY_PV}"
	dosym "libamfrt64.so.${MY_PV}" "/usr/$(get_libdir)/libamfrt64.so.1"

	doins "${S}/${PN}-amd64/opt/amdgpu-pro/lib/x86_64-linux-gnu/libamdenc64.so.1.0"
	doins "${S}/${PN}-amd64/opt/amdgpu-pro/lib/x86_64-linux-gnu/libamdenc64.so"
}
