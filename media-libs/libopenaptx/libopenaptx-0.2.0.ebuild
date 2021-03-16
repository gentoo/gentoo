# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Reverse-engineered aptX and aptX HD library"
HOMEPAGE="https://github.com/pali/libopenaptx"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pali/${PN}"
else
	SRC_URI="https://github.com/pali/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
IUSE="cpu_flags_x86_avx2"

LICENSE="LGPL-2.1"
SLOT="0"

RDEPEND=""
DEPEND="${RDEPEND}"

src_compile() {
	use cpu_flags_x86_avx2 && append-cflags "-mavx2"

	emake PREFIX="${EPREFIX}"/usr DESTDIR="${D}" LIBDIR=$(get_libdir) \
		  CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS" ARFLAGS="$ARFLAGS -rcs" all
}

src_install() {
	emake PREFIX="${EPREFIX}"/usr DESTDIR="${D}" LIBDIR=$(get_libdir) \
		  CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS" ARFLAGS="$ARFLAGS -rcs" install

	#rm static lib
	rm -f "${D}/usr/$(get_libdir)"/libopenaptx.a || die "rm libopenaptx.a"
}
