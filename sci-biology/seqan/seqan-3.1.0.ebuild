# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ Sequence Analysis Library"
HOMEPAGE="https://www.seqan.de/"
SRC_URI="https://github.com/seqan/seqan3/releases/download/${PV}/seqan3-${PV}-Source.tar.xz"
S="${WORKDIR}/seqan3-${PV}-Source"

LICENSE="BSD GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="cpu_flags_x86_sse4_2"
REQUIRED_USE="cpu_flags_x86_sse4_2"

RDEPEND="
	app-arch/bzip2:=
	dev-cpp/range-v3
	dev-libs/cereal
	sci-libs/lemon
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}"

src_install() {
	cmake_src_install
	dodoc -r doc/*
}
