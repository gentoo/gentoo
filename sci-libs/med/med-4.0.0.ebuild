# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils flag-o-matic

DESCRIPTION="Modeling and Exchange of Data library"
HOMEPAGE="https://www.salome-platform.org/user-section/about/med"
SRC_URI="https://files.salome-platform.org/Salome/other/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mpi"

RDEPEND="
	${PYTHON_DEPS}
	>=sci-libs/hdf5-1.10.5[mpi=]
	mpi? ( virtual/mpi )
"

DEPEND="
	${DEPEND}
"

src_prepare() {
	default
	append-cppflags -DH5_USE_16_API
}

src_configure() {
	local myconf=(
		--docdir="/usr/share/doc/${PF}"
		--disable-python
	)

	econf "${myconf[@]}"
}

src_install() {
	default

	mv "${ED}"/usr/$(get_libdir)/libmed3.settings \
		"${ED}"/usr/share/doc/${PF}/ || die "mv failed"

	rm -rf "${ED}"/usr/include/2.3.6 || die "rm failed"
}
