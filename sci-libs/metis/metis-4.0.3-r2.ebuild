# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools eutils fortran-2

DESCRIPTION="A package for unstructured serial graph partitioning"
HOMEPAGE="http://www-users.cs.umn.edu/~karypis/metis/metis/"
SRC_URI="http://glaros.dtc.umn.edu/gkhome/fetch/sw/${PN}/OLD/${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"
RESTRICT="mirror bindist"

DEPEND=""
RDEPEND="
	${DEPEND}
	!sci-libs/parmetis
"

src_prepare() {
	eapply -p1 "${FILESDIR}/${PN}-4.0.1-autotools.patch"
	eapply_user
	sed -i -e "s/4.0.1/${PV}/" configure.ac || die
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	use doc && dodoc Doc/manual.ps
	find "${D}" -name '*.la' -delete || die
}
