# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/vc/vc-0.7.4.ebuild,v 1.3 2015/03/11 21:52:35 amadio Exp $

EAPI=5

inherit vcs-snapshot cmake-utils

VC_TEST_DATA=( reference-{acos,asin,atan,ln,log2,log10,sincos}-{dp,sp}.dat )
for i in ${VC_TEST_DATA[@]}; do
	SRC_URI+="test? ( http://compeng.uni-frankfurt.de/~kretz/Vc-testdata/$i -> ${P}-${i} ) "
done

DESCRIPTION="A library to ease explicit vectorization of C++ code"
HOMEPAGE="http://code.compeng.uni-frankfurt.de/projects/vc"
SRC_URI+="http://code.compeng.uni-frankfurt.de/attachments/download/183/Vc-0.7.4.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~x86 ~x86-linux"
IUSE="test"

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
		$(cmake-utils_use_build test)
	)
	cmake-utils_src_configure
}
