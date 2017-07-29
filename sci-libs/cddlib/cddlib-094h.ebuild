# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

DESCRIPTION="C implementation of the Double Description Method of Motzkin et al"
HOMEPAGE="https://www.inf.ethz.ch/personal/fukudak/cdd_home/"
SRC_URI="ftp://ftp.math.ethz.ch/users/fukudak/cdd/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs tools"

DEPEND="dev-libs/gmp:0="
RDEPEND="${DEPEND}"

DOCS=( ChangeLog README )

PATCHES=(
	"${FILESDIR}"/${P}-add-cdd_both_reps-binary.patch
	"${FILESDIR}"/${P}-enforce-no-gmp.patch
)

src_prepare() {
	default
	sed -e 's|localdebug=dd_TRUE|localdebug=dd_FALSE|g' \
		-i lib-src/cddlp.c -i lib-src-gmp/cddlp.c -i lib-src-gmp/cddlp_f.c || die
	cp "${FILESDIR}"/cdd_both_reps.c src || die
	ln -s "${S}"/src/cdd_both_reps.c "${S}"/src-gmp/cdd_both_reps.c || die
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	use tools || rm "${ED}"/usr/bin/*
	use static-libs || prune_libtool_files --all
	use doc && dodoc doc/cddlibman.pdf
}
