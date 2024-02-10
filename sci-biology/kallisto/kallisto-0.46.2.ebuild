# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Near-optimal RNA-Seq quantification"
HOMEPAGE="http://pachterlab.github.io/kallisto/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pachterlab/kallisto.git"
else
	SRC_URI="https://github.com/pachterlab/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="BSD"
SLOT="0"
IUSE="hdf5 test"
RESTRICT="!test? ( test )"

RDEPEND="
	sci-libs/htslib:=
	sys-libs/zlib:=
	hdf5? ( sci-libs/hdf5:= )"
DEPEND="
	${RDEPEND}
	test? (
		dev-cpp/catch:0
		sci-libs/hdf5
	)"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-cmake.patch
	"${FILESDIR}"/${P}-htslib.patch
	"${FILESDIR}"/${P}-catch2.patch
	"${FILESDIR}"/${P}-gcc11.patch
)

src_prepare() {
	cmake_src_prepare
	# bundled catch2
	rm -r ext || die
	# bundled htslib structs
	rm src/kseq.h || die

	# the test suite is cheesy and relies on a
	# specific builddir nesting structure.
	sed -e "s|../test/input/short_reads.fastq|$(readlink -f unit_tests/input/short_reads.fastq)|g" \
		-i unit_tests/test_kmerhashtable.cpp || die
}

src_configure() {
	local mycmakeargs=(
		-DUSE_HDF5=$(usex hdf5)
		-DBUILD_TESTING=$(usex test)
		# convenience library only
		-DBUILD_SHARED_LIBS=OFF
	)
	cmake_src_configure
}
