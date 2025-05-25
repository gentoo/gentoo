# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

DESCRIPTION="The protein secondary structure standard"
HOMEPAGE="https://swift.cmbi.umcn.nl/gv/dssp/ https://github.com/PDB-REDO/dssp"
SRC_URI="https://github.com/PDB-REDO/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# doc disabled as it only generates a PDF from the manpage for now
# https://github.com/PDB-REDO/dssp/issues/64
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND="
	dev-libs/boost:=[zlib]
	>=dev-libs/libmcfp-1.4.2
	>=sci-libs/libcifpp-8.0.1
"
BDEPEND="${CDEPEND}
	dev-cpp/catch:0
"
#	doc? (
#		|| ( app-text/pandoc-bin[pandoc-symlink] app-text/pandoc )
#		dev-python/weasyprint
#	)
RDEPEND="${CDEPEND}"

#src_prepare() {
#	# wkhtmltopdf is not available on Gentoo
#	sed -i -e \
#		's/-t html/-t html --pdf-engine=weasyprint/' \
#		CMakeLists.txt
#	cmake_src_prepare
#}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIBRARY=YES
		#-DBUILD_DOCUMENTATION=$(usex doc)
		-DBUILD_DOCUMENTATION=NO
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	# Collides with libcifpp provided file
	rm -v "${ED}/usr/share/libcifpp/mmcif_pdbx.dic" || die
}
