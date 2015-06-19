# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/shapelib/shapelib-1.3.0-r1.ebuild,v 1.11 2012/12/23 11:29:32 maekke Exp $

EAPI=4
inherit eutils toolchain-funcs multilib versionator

DESCRIPTION="Library for manipulating ESRI Shapefiles"
HOMEPAGE="http://shapelib.maptools.org/"
SRC_URI="http://download.osgeo.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND=""
RDEPEND=""

static_to_shared() {
	local libstatic=${1}; shift
	local libname=$(basename ${libstatic%.a})
	local soname=${libname}$(get_libname $(get_version_component_range 1-2))
	local libdir=$(dirname ${libstatic})

	einfo "Making ${soname} from ${libstatic}"
	if [[ ${CHOST} == *-darwin* ]] ; then
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-dynamiclib -install_name "${EPREFIX}"/usr/lib/"${soname}" \
			-Wl,-all_load -Wl,${libstatic} \
			"$@" -o ${libdir}/${soname} || die "${soname} failed"
	else
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-shared -Wl,-soname=${soname} \
			-Wl,--whole-archive ${libstatic} -Wl,--no-whole-archive \
			"$@" -o ${libdir}/${soname} || die "${soname} failed"
		[[ $(get_version_component_count) -gt 1 ]] && \
			ln -s ${soname} ${libdir}/${libname}$(get_libname $(get_major_version))
		ln -s ${soname} ${libdir}/${libname}$(get_libname)
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-respect-user.patch
	tc-export CC AR
}

src_compile() {
	emake CFLAGS="${CFLAGS} -fPIC" lib
	static_to_shared lib*.a
	rm *.o *.a
	emake
}

src_test() {
	emake test
}

src_install() {
	dobin shp{create,dump,add} dbf{create,dump,add}
	insinto /usr/include/libshp
	doins shapefil.h
	use test && dobin shptest
	dolib.so lib*$(get_libname)*
	dodoc ChangeLog README*
	use static-libs && dolib.a lib*.a
}
