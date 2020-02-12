# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A programmer's API and an end-user's toolkit for handling BAM files"
HOMEPAGE="https://github.com/pezmaster31/bamtools"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pezmaster31/bamtools.git"
else
	SRC_URI="https://github.com/pezmaster31/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0/${PV}" # no stable ABI yet

RDEPEND="
	>=dev-libs/jsoncpp-1.8.0:=
	sys-libs/zlib:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	# delete bundled libs, just to be safe
	rm -rf src/third_party/{gtest-1.6.0,jsoncpp} || die

	cmake_src_prepare
}
