# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic cmake

DESCRIPTION="Scalable Video Technology for HEVC (SVT-HEVC Encoder)"
HOMEPAGE="https://github.com/OpenVisualCloud/SVT-HEVC"

if [ ${PV} = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OpenVisualCloud/SVT-HEVC.git"
else
	SRC_URI="https://github.com/OpenVisualCloud/SVT-HEVC/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/SVT-HEVC-${PV}"
fi

LICENSE="AOM BSD-2"
SLOT="0"

BDEPEND="dev-lang/nasm"

src_prepare() {
	append-ldflags -Wl,-z,noexecstack
	cmake_src_prepare
}
