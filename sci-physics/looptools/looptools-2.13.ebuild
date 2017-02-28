# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit fortran-2

MY_P=LoopTools-${PV}

DESCRIPTION="Tools for evaluation of scalar and tensor one-loop integrals"
HOMEPAGE="http://www.feynarts.de/looptools"
SRC_URI="http://www.feynarts.de/looptools/${MY_P}.tar.gz"

LICENSE="LGPL-3"

SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

PATCHES=( "${FILESDIR}"/${PN}-2.10-makefile.patch )

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	export VER="${PV}"
	# necessary fix for prefix
	sed -i "s/lib\$(LIBDIRSUFFIX)/$(get_libdir)/" makefile.in || die
}

src_install() {
	default

	# another one of these package building archive with pic
	# no: ooptools is not a typo
	if ! use static-libs; then
		rm "${ED%/}"/usr/$(get_libdir)/libooptools.a || die
	fi
	use doc && dodoc manual/*.pdf
}
