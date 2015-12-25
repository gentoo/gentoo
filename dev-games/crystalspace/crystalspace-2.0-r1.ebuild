# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
WX_GTK_VER="3.0"
inherit eutils flag-o-matic multilib java-pkg-opt-2 autotools wxwidgets versionator multiprocessing

MY_P=${PN}-src-${PV}
PATH_P=${PN}-$(get_version_component_range 1-2)

DESCRIPTION="Portable 3D Game Development Kit written in C++"
HOMEPAGE="http://crystal.sourceforge.net/"
SRC_URI="mirror://sourceforge/crystal/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="3ds alsa bullet cal3d cegui cg doc java jpeg mng ode png speex truetype vorbis wxwidgets"

COMMON_DEP="virtual/opengl
	media-libs/openal
	x11-libs/libXt
	x11-libs/libXxf86vm
	sys-libs/zlib
	cg? ( media-gfx/nvidia-cg-toolkit )
	ode? ( <dev-games/ode-0.12 )
	cal3d? ( >=media-libs/cal3d-0.11 )
	jpeg? ( virtual/jpeg:0 )
	bullet? ( sci-physics/bullet )
	vorbis? ( media-libs/libvorbis )
	speex? ( media-libs/libogg
		media-libs/speex )
	truetype? ( >=media-libs/freetype-2.1 )
	alsa? ( media-libs/alsa-lib )
	mng? ( media-libs/libmng )
	png? ( media-libs/libpng:0 )
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}[X,opengl] )
	cegui? ( >=dev-games/cegui-0.5.0 )
	3ds? ( media-libs/lib3ds )"

RDEPEND="${COMMON_DEP}
	java? ( >=virtual/jre-1.5 )"

DEPEND="${COMMON_DEP}
	java? ( >=virtual/jdk-1.5
		dev-java/ant-core )
	dev-util/ftjam
	dev-lang/swig
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# Installing doc conflict with dodoc on src_install
	# Removing conflicting target
	sed -i \
		-e "/^InstallDoc/d" \
		Jamfile.in \
		docs/Jamfile || die
	epatch \
		"${FILESDIR}"/${P}-gcc47.patch \
		"${FILESDIR}"/${P}-wxgtk.patch
	use wxwidgets && append-libs -lGL
	AT_M4DIR=mk/autoconf \
		eautoreconf
}

src_configure() {
	if use wxwidgets; then
		need-wxwidgets unicode
	fi

	econf \
		--disable-as-needed \
		--enable-cpu-specific-optimizations=no \
		--disable-separate-debug-info \
		--without-lcms \
		--without-jackasyn \
		--without-perl \
		$(use_with java) \
		--disable-make-emulation \
		$(use_with bullet) \
		--without-python \
		$(use_with png) \
		$(use_with jpeg) \
		$(use_with mng) \
		$(use_with vorbis) \
		$(use_with speex) \
		$(use_with 3ds) \
		$(use_with ode) \
		$(use_with truetype freetype2) \
		$(use_with cal3d) \
		$(use_with wxwidgets wx) \
		$(use_with cegui CEGUI) \
		$(use_with cg Cg) \
		$(use_with alsa asound)
	#remove unwanted CFLAGS added by ./configure
	sed -i -e '/COMPILER\.CFLAGS\.optimize/d' \
		Jamconfig || die
}

src_compile() {
	jam -q -dx -j$(makeopts_jobs) || die
}

src_install() {
	for installTarget in bin plugin lib include data config bindings
	do
		jam -q -s DESTDIR="${D}" install_${installTarget} || die
	done
	if use doc; then
		jam -q -s DESTDIR="${D}" install_doc || die
	fi
	dodoc README docs/history*

	echo "CRYSTAL_PLUGIN=/usr/$(get_libdir)/${PATH_P}" > 90crystalspace
	echo "CRYSTAL_CONFIG=/etc/${PATH_P}" >> 90crystalspace
	doenvd 90crystalspace
}

pkg_postinst() {
	elog "Examples coming with this package, need correct light calculation"
	elog "Do the following commands, with the root account, to fix that:"
	# Fill cache directory for the examples
	local dir
	for dir in castle flarge isomap parallaxtest partsys r3dtest stenciltest \
		terrain terrainf;
	do
		elog "cslight -video=null /usr/share/${PATH_P}/data/maps/${dir}"
	done
}
