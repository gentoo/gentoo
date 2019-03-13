# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Utility to create and demux TS and M2TS files"
HOMEPAGE="http://forum.doom9.org/showthread.php?t=168539"
SRC_URI="https://drive.google.com/uc?export=download&id=0B0VmPcEZTp8NekJxLUVJRWMwejQ -> ${P}.tar.gz"

LICENSE="SmartLabs"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

QA_FLAGS_IGNORED="opt/${PN}/bin/tsMuxeR opt/${PN}/bin/tsMuxerGUI"

DEPEND="|| (
	>=app-arch/upx-ucl-3.01[lzma]
	>=app-arch/upx-bin-3.01
)"
RDEPEND="
	>=media-libs/freetype-2.5.0.1:2[abi_x86_32(-)]
"

S="${WORKDIR}"

src_prepare() {
	default
	upx -d tsMuxeR tsMuxerGUI || die
}

src_install() {
	dodir /opt/bin
	exeinto /opt/${PN}/bin

	doexe tsMuxeR
	dosym ../${PN}/bin/tsMuxeR /opt/bin/tsMuxeR
}
