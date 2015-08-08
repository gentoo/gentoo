# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools eutils

MY_P=${P/_rc/RC}

DESCRIPTION="Library for reading TIFF files with embedded tags for geographic (cartographic) information"
HOMEPAGE="http://geotiff.osgeo.org/"
SRC_URI="http://download.osgeo.org/geotiff/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="debug doc static-libs"

RDEPEND="
	virtual/jpeg
	>=media-libs/tiff-3.9.1:0
	sci-libs/proj
	sys-libs/zlib"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${MY_P/RC*/}

DOCS=( README ChangeLog )

src_prepare() {
	epatch_user
	sed -i \
		-e "s:-O3::g" \
		configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--enable-debug=$(use debug && echo yes || echo no) \
		--with-jpeg="${EPREFIX}"/usr/ \
		--with-zip="${EPREFIX}"/usr/

}
src_compile() {
	default

	if use doc; then
		mkdir -p docs/api
		cp "${FILESDIR}"/Doxyfile Doxyfile
		doxygen -u Doxyfile || die "updating doxygen config failed"
		doxygen Doxyfile || die "docs generation failed"
	fi
}

src_install() {
	default

	use doc && dohtml docs/api/*
	prune_libtool_files
}

pkg_postinst() {
	echo
	ewarn "You should rebuild any packages built against ${PN} by running:"
	ewarn "# revdep-rebuild"
	ewarn "or using preserved-rebuild features of portage-2.2:"
	ewarn "# emerge @preserved-rebuild"
	echo
}
