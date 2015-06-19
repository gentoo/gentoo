# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/proj/proj-4.8.0.ebuild,v 1.12 2015/01/05 15:20:47 aballier Exp $

EAPI=4

inherit eutils java-pkg-opt-2 flag-o-matic

DESCRIPTION="Proj.4 cartographic projection software with updated NAD27 grids"
HOMEPAGE="http://trac.osgeo.org/proj/"
SRC_URI="
	ftp://ftp.remotesensing.org/pub/proj/${P}.tar.gz
	http://download.osgeo.org/proj/${PN}-datumgrid-1.5.zip
	http://trac.osgeo.org/proj/export/2190/tags/${PV}/proj/src/org_proj4_PJ.h -> ${P}-org_proj4_PJ.h
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="java static-libs"

RDEPEND=""
DEPEND="
	app-arch/unzip
	java? ( >=virtual/jdk-1.5 )"

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"/nad || die
	mv README README.NAD || die
	cp "${DISTDIR}/${P}-org_proj4_PJ.h" "${S}/src/org_proj4_PJ.h" || die
	unpack ${PN}-datumgrid-1.5.zip
}

src_configure() {
	if use java; then
		export JAVACFLAGS="$(java-pkg_javac-args)"
		append-cflags "$(java-pkg_get-jni-cflags)"
	fi
	econf \
		$(use_enable static-libs static) \
		$(use_with java jni)
}

src_install() {
	default
	cd nad || die
	dodoc README.{NAD,NADUS}
	insinto /usr/share/proj
	insopts -m 755
	doins test27 test83
	insopts -m 644
	doins pj_out27.dist pj_out83.dist
	prune_libtool_files
}
