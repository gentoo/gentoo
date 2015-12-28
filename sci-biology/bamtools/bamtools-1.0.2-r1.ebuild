# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="A programmer's API and an end-user's toolkit for handling BAM files"
HOMEPAGE="https://github.com/pezmaster31/bamtools"
SRC_URI="mirror://github/pezmaster31/bamtools/"${P}".tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/jsoncpp
	sys-libs/zlib"
DEPEND="${RDEPEND}"

src_prepare() {
	sed \
		-e '/third_party/d' \
		-i src/CMakeLists.txt || die
	rm -r src/third_party || die

	sed \
		-e 's:json.h:json/json.h:g' \
		-i src/toolkit/bamtools_filter.cpp || die

	cmake-utils_src_prepare
}

src_install() {
	local i
	for i in bin/bamtools-${PV} lib/libbamtools.so.${PV} lib/libbamtools-utils.so.${PV}; do
		TMPDIR="$(pwd)" scanelf -Xr $i || die
	done

	dobin bin/bamtools
	dolib.so lib/*so*
	use static-libs && dolib.a lib/*a
	insinto /usr/include/bamtools
	doins include/api include/shared
	dodoc README
}
