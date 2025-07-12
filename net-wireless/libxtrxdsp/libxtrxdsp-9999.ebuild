# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

DESCRIPTION="DSP specific function for SDR in general and XTRX in specific"
HOMEPAGE="https://github.com/xtrx-sdr/libxtrxdsp"
if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/xtrx-sdr/libxtrxdsp.git"
else
	COMMIT="eec28640c0ebd5639b642f07b310a0a0d02d9834"
	SRC_URI="https://github.com/xtrx-sdr/libxtrxdsp/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"

src_prepare() {
	# fix build with cmake 4
	sed -i -e "s/VERSION 2.8/VERSION 3.10/" CMakeLists.txt || die
	cmake_src_prepare
}
