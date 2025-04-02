# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Library with convenience functions used mainly by sys-apps/66"
HOMEPAGE="https://web.obarun.org/software/"
SRC_URI="https://git.obarun.org/Obarun/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="0BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static static-libs"

DEPEND=">=dev-libs/skalibs-2.14.3.0"
RDEPEND=">=dev-lang/execline-2.9.6.1
!static? ( ${DEPEND} )"

src_configure() {
 local econfargs=(
 "--with-sysdeps=${EPREFIX}/usr/$(get_libdir)/skalibs"
 "--dynlibdir=${EPREFIX}/usr/$(get_libdir)"
 "--libdir=${EPREFIX}/usr/$(get_libdir)/${PN}"
 )

 if use static; then econfargs+=("--enable-allstatic" "--disable-shared"); fi
 if use static-libs; then econfargs+=("--enable-static"); fi

 econf ${econfargs[@]}
}
