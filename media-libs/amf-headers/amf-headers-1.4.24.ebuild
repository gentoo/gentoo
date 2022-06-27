# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/GPUOpen-LibrariesAndSDKs/AMF"
else
	SRC_URI="https://github.com/GPUOpen-LibrariesAndSDKs/AMF/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="The Advanced Media Framework (AMF) SDK"
HOMEPAGE="https://github.com/GPUOpen-LibrariesAndSDKs/AMF"

LICENSE="MIT"
SLOT="0"
IUSE=""

S="${WORKDIR}/AMF-${PV}"

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
