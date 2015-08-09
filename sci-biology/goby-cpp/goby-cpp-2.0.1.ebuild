# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils

DESCRIPTION="A DNA sequencing data management framework - C/C++ API"
HOMEPAGE="http://campagnelab.org/software/goby/"
SRC_URI="http://chagall.med.cornell.edu/goby/releases/archive/release-goby_${PV}/goby_${PV}-cpp.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="
	>=dev-libs/protobuf-2.4.1
	>=dev-libs/libpcre-8.12"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PV}/cpp"

PATCHES=(
	"${FILESDIR}"/${P}-underlinking.patch
)

src_prepare() {
	sed \
		-e '/BUILD_TIMESTAMP/s:\(goby/timestamp.h\):$(top_srcdir)/src/\1:g' \
		-i src/Makefile.am || die

	pushd src/goby > /dev/null || die
	cp "${FILESDIR}"/*.proto . || die
	protoc --cpp_out=. *.proto || die
	popd > /dev/null || die

	autotools-utils_src_prepare
}
