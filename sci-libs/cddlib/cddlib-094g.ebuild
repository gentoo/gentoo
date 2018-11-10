# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="C implementation of the Double Description Method of Motzkin et al"
HOMEPAGE="http://www.ifor.math.ethz.ch/~fukuda/cdd_home/"
SRC_URI="ftp://ftp.ifor.math.ethz.ch/pub/fukuda/cdd/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

DEPEND=">=dev-libs/gmp-4.2.2:0="
RDEPEND="${DEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD="1"

DOCS=( ChangeLog README )

PATCHES=(
	"${FILESDIR}"/${P}-add-cdd_both_reps-binary.patch
)

src_prepare() {
	autotools-utils_src_prepare

	cp "${FILESDIR}"/cdd_both_reps.c "${S}"/src/ \
		|| die "failed to copy source file"
	ln -s "${S}"/src/cdd_both_reps.c "${S}"/src-gmp/cdd_both_reps.c \
		|| die "failed to make symbolic link to source file"
}

src_install() {
	use doc && DOCS+=( doc/cddlibman.pdf doc/cddlibman.ps )

	autotools-utils_src_install
}
