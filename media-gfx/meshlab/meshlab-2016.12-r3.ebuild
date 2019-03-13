# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="the open source system for processing and editing 3D triangular meshes"
HOMEPAGE="http://www.meshlab.net"
VCG_VERSION="1.0.1"
SRC_URI="https://github.com/cnr-isti-vclab/meshlab/archive/v${PV}.tar.gz -> ${P}.tar.gz
	 https://github.com/cnr-isti-vclab/vcglib/archive/v${VCG_VERSION}.tar.gz -> vcglib-${VCG_VERSION}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-minimal"
DEPEND="dev-cpp/eigen:3
	dev-cpp/muParser
	dev-qt/qtcore:5
	dev-qt/qtopengl:5
	dev-qt/qtscript:5
	dev-qt/qtxmlpatterns:5
	>=media-gfx/jhead-3.00-r2
	media-libs/glew:0
	media-libs/qhull
	=media-libs/lib3ds-1*
	media-libs/openctm
	sci-libs/levmar
	sci-libs/mpir"

RDEPEND="${DEPEND}"

S="${WORKDIR}/meshlab-${PV}/src"

PATCHES=(
		"${FILESDIR}/${PV}/0001-set-shader-and-texture-paths.patch"
		#remove ot working plugins
		"${FILESDIR}/${PV}/remove-edit_mutualcorrs.patch"
		"${FILESDIR}/${PV}/remove-io_TXT.patch"
		#since structure synth doesn't seem to be compiling
		"${FILESDIR}/${PV}/0001-disable-filter-ssynth.patch"
		#this has been fixed in the tree
		"${FILESDIR}/${PV}/0001-disable-edit-quality.patch"
		#this causes segfaults
		"${FILESDIR}/${PV}/0001-disable-filter-layer.patch"
		#for when we use minimal
		"${FILESDIR}/${PV}/0001-compile-server.patch"
		"${FILESDIR}/${PV}/0001-use-external-lib3ds.patch"
		"${FILESDIR}/${PV}/0001-use-external-openctm.patch"
		"${FILESDIR}/${PV}/0001-use-external-muParser.patch"
		"${FILESDIR}/${PV}/0001-use-external-bzip.patch"
		"${FILESDIR}/${PV}/0001-use-external-jhead.patch"
		"${FILESDIR}/${PV}/0001-use-external-glew.patch"
		#cause gnu stack quickstart related qa
		"${FILESDIR}/${PV}/0001-remove-not-sane-plugins.patch"
		"${FILESDIR}/${PV}/${P}-fix-plugins-path.patch"
		"${FILESDIR}/${PV}/${P}-align1.patch"
		"${FILESDIR}/${PV}/${P}-align2.patch"
		"${FILESDIR}/${PV}/${P}-asString.patch"
	)

src_prepare(){
	mv "${WORKDIR}/vcglib-${VCG_VERSION}" "${WORKDIR}/vcglib" || die "vcglib mv failed"
	default
	#proof of patchset
	#remove libs that are being used from the system
	rm -r "external/lib3ds-1.3.0" || die "rm failed"
	rm -r "external/OpenCTM-1.0.3" || die "rm failed"
	rm -r "external/muparser_v132" || die "rm failed"
	rm -r "external/muparser_v225" || die "rm failed"
	rm -r "external/bzip2-1.0.5" || die "rm failed"
	rm -r "external/jhead-2.95" || die "rm failed"
	rm -r "external/glew-1.5.1" || die "rm failed"
	rm -r "external/glew-1.7.0" || die "rm failed"
	#we still depend on lm.h
	#rm -r "external"
	rm -r "distrib/plugins/U3D_W32" || die
	rm -r "distrib/plugins/U3D_OSX" || die

	# Fix bug 638796
	cd "${WORKDIR}" || die
	eapply "${FILESDIR}/${PV}/${P}-remove-header.patch"
}

src_configure() {
	use minimal || eqmake5 -r meshlab_full.pro
	use minimal && eqmake5 -r meshlab_mini.pro
}

src_install() {
	dobin distrib/{meshlab,meshlabserver}
	dolib distrib/libcommon.so.1.0.0
	dosym libcommon.so.1.0.0 /usr/$(get_libdir)/libcommon.so.1
	dosym libcommon.so.1 /usr/$(get_libdir)/libcommon.so
	exeinto /usr/$(get_libdir)/meshlab/plugins
	doexe distrib/plugins/*.so
	insinto /usr/share/meshlab/shaders
	doins -r distrib/shaders/*
	insinto /usr/share/meshlab/plugins
	doins -r distrib/plugins/*
	insinto /usr/share/meshlab/textures
	doins -r distrib/textures/*
	insinto /usr/share/meshlab/sample
	doins -r distrib/sample/*
	newicon "${S}"/meshlab/images/eye512.png "${PN}".png
	make_desktop_entry meshlab "Meshlab" "${PN}" Graphics
}
