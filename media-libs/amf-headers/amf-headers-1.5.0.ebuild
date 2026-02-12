# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/GPUOpen-LibrariesAndSDKs/AMF"
else
	SRC_URI="https://github.com/GPUOpen-LibrariesAndSDKs/AMF/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

	# ffmpeg with amf USE enabled
	# - can only built with amf-headers installed.
	# - can only use AMF ( the 'XXXX_amf' codecs) at runtime when 'amdgpu-pro-amf' is installed (the shared libs it installs are dlopen'ed by ffmpeg)
	# - can only use the AMF features that it has explicit code for
	# Given that amdgpu-pro-amf is on top of that a proprietary binary
	# -> we straight to stable when ver-bumping 'amdgpu-pro-amf' and `amf-headers'
	KEYWORDS="amd64 arm64"
fi

DESCRIPTION="The Advanced Media Framework (AMF) SDK"
HOMEPAGE="https://github.com/GPUOpen-LibrariesAndSDKs/AMF"

S="${WORKDIR}/AMF-${PV}"

LICENSE="MIT"
SLOT="0"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.36-static-inline.patch
)

src_unpack() {
	default

	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	fi
}

src_install() {
	insinto "/usr/include/AMF"
	doins -r "${S}/amf/public/include/"*
}
