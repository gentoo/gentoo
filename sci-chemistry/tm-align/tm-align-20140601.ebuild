# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/tm-align/tm-align-20140601.ebuild,v 1.5 2015/05/17 20:19:32 pacho Exp $

EAPI=5

inherit cmake-utils flag-o-matic fortran-2

DESCRIPTION="Quick & Accurate Structural Alignment"
HOMEPAGE="http://zhanglab.ccmb.med.umich.edu/TM-align/"
SRC_URI="http://zhanglab.ccmb.med.umich.edu/TM-align/TMtools${PV}.tar.gz"

LICENSE="tm-align"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="static custom-cflags"

S="${WORKDIR}"

src_prepare() {
	cp "${FILESDIR}"/CMakeLists.txt . || die
	use static && append-fflags -static && append-ldflags -static
	# recommended by upstream
	use custom-cflags || replace-flags -O* -O3 && append-fflags -ffast-math
}
