# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="SIMD Vector Class Library for C++"
HOMEPAGE="https://github.com/VcDevel/Vc"

VC_TEST_DATA=( reference-{acos,asin,atan,ln,log2,log10,sincos}-{dp,sp}.dat )
for i in ${VC_TEST_DATA[@]}; do
	SRC_URI+="test? ( http://compeng.uni-frankfurt.de/~kretz/Vc-testdata/$i -> ${P}-${i} ) "
done

SRC_URI+="https://github.com/VcDevel/Vc/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

src_unpack() {
	default_src_unpack
	S="${WORKDIR}"/Vc-${PV}
	if use test ; then
		mkdir -p "${WORKDIR}"/${P}_build/tests || die
		for i in ${VC_TEST_DATA[@]}; do
			cp "${DISTDIR}"/${P}-$i "${WORKDIR}"/${P}_build/tests/${i} || die
		done
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)
	cmake-utils_src_configure
}
