# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="High-level XTRX API library"
HOMEPAGE="https://github.com/xtrx-sdr/libxtrx"
LICENSE="LGPL-2.1"
SLOT="0/${PV}"

if [[ ${PV} =~ "9999" ]]; then
	EGIT_REPO_URI="https://github.com/xtrx-sdr/libxtrx.git"
	inherit git-r3
else
	COMMIT="acb0b1cf7ab92744034767a04c1d4b4c281b840f"
	SRC_URI="https://github.com/xtrx-sdr/libxtrx/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

IUSE=""

RDEPEND="
		net-wireless/libxtrxll:=
		net-wireless/libxtrxdsp:=
		net-wireless/liblms7002m:=
"
#		soapy? ( net-wireless/soapysdr )
DEPEND="${RDEPEND}"

src_configure() {
	#fails to build, not sure why
	#-DENABLE_SOAPY="$(usex soapy ON OFF)"
	mycmakeargs=(
		-DENABLE_SOAPY=OFF
	)
	cmake_src_configure
}
