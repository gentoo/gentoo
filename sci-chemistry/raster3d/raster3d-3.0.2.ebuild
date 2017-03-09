# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils fortran-2 flag-o-matic multilib toolchain-funcs versionator prefix

MY_PN="Raster3D"
MY_PV=$(replace_version_separator 2 -)
MY_P="${MY_PN}_${MY_PV}"

DESCRIPTION="Generation high quality raster images of proteins or other molecules"
HOMEPAGE="http://www.bmsc.washington.edu/raster3d/raster3d.html"
SRC_URI="http://www.bmsc.washington.edu/${PN}/${MY_P}.tar.gz -> ${MY_P}.tar"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="gd tiff"

RDEPEND="
	tiff? ( media-libs/tiff:0 )
	gd? ( media-libs/gd[jpeg,png] )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-as-needed.patch \
		"${FILESDIR}"/${PV}-gentoo-prefix.patch

	sed \
		-e "s:MYPF:${PF}:" \
		-e "s:MYLIB:$(get_libdir):g" \
		-i Makefile.template || \
		die "Failed to patch makefile.template"

	if ! use gd; then
		sed \
			-e "/GDLIBS/s:^:#:g" \
			-e "/GDDEFS/s:^:#:g" \
			-i Makefile.template || die
	fi

	if ! use tiff; then
		sed \
			-e "/TLIBS/s:^:#:g" \
			-e "/TDEFS/s:^:#:g" \
			-i Makefile.template || die
	fi

	if [[ $(tc-getFC) =~ gfortran ]]; then
		append-cflags -Dgfortran
	fi

	append-fflags -ffixed-line-length-132

	eprefixify Makefile.template
	cp Makefile.template Makefile.incl || die
}

src_compile() {
	local target
	local i

	if [[ $(tc-getFC) =~ gfortran ]]; then
		target="linux"
	else
		target="linux-$(tc-getFC)"
	fi

	for i in render.o ${target} all; do
		emake \
			CFLAGS="${CFLAGS}" \
			LDFLAGS="${LDFLAGS}" \
			FFLAGS="${FFLAGS}" \
			CC="$(tc-getCC)"\
			FC="$(tc-getFC)" \
			INCDIRS="-I${EPREFIX}/usr/include" \
			LIBDIRS="-L${EPREFIX}/usr/$(get_libdir)" \
			${i}
	done
}

src_install() {
	emake prefix="${ED}"/usr \
			bindir="${ED}"/usr/bin \
			datadir="${ED}"/usr/share/Raster3D/materials \
			mandir="${ED}"/usr/share/man/man1 \
			htmldir="${ED}"/usr/share/doc/${PF}/html \
			examdir="${ED}"/usr/share/Raster3D/examples \
			install

	dodir /etc/env.d
	echo -e "R3D_LIB=${EPREFIX}/usr/share/${NAME}/materials" > \
		"${ED}"/etc/env.d/10raster3d || \
		die "Failed to install env file."
}

pkg_postinst() {
	elog "Add following line:"
	elog "<delegate decode=\"r3d\" command='\"render\" < \"%i\" > \"%o\"' />"
	elog "to ${EPREFIX}/usr/$(get_libdir)/ImageMagick-6.5.8/config/delegates.xml"
	elog "to make imagemagick use raster3d for .r3d files"
}
