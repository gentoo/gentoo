# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

PYTHON_DEPEND="python? 2"
WANT_AUTOCONF="2.1"

inherit eutils gnome2 multilib python versionator wxwidgets autotools

MY_PM=${PN}$(get_version_component_range 1-2 ${PV})
MY_PM=${MY_PM/.}
MY_P=${P/_rc/RC}

DESCRIPTION="A free GIS with raster and vector functionality, as well as 3D vizualization"
HOMEPAGE="http://grass.osgeo.org/"
SRC_URI="http://grass.osgeo.org/${MY_PM}/source/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="6"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE="X cairo cxx ffmpeg fftw gmath jpeg motif mysql nls odbc opengl png postgres python readline sqlite tiff truetype wxwidgets"

TCL_DEPS="
	>=dev-lang/tcl-8.5:0
	>=dev-lang/tk-8.5:0
	"

RDEPEND="
	>=app-admin/eselect-1.2
	sci-libs/gdal
	sci-libs/proj
	sys-libs/gdbm
	sys-libs/ncurses
	sys-libs/zlib
	cairo? ( x11-libs/cairo[X?,opengl?] )
	ffmpeg? ( >=virtual/ffmpeg-0.10 )
	fftw? ( sci-libs/fftw:3.0 )
	gmath? (
		virtual/blas
		virtual/lapack
	)
	jpeg? ( virtual/jpeg:0 )
	mysql? ( virtual/mysql )
	odbc? ( dev-db/unixODBC )
	opengl? (
		virtual/opengl
		${TCL_DEPS}
	)
	png? ( media-libs/libpng:0 )
	postgres? ( >=dev-db/postgresql-8.4 )
	readline? ( sys-libs/readline:0 )
	sqlite? ( dev-db/sqlite:3 )
	tiff? ( media-libs/tiff:0 )
	truetype? ( media-libs/freetype:2 )
	wxwidgets? ( >=dev-python/wxpython-2.8.10.1[cairo,opengl?] )
	X? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXaw
		x11-libs/libXext
		x11-libs/libXmu
		x11-libs/libXp
		x11-libs/libXpm
		x11-libs/libXt
		motif? (
			>=x11-libs/motif-2.3:0
			opengl? (
				|| (
					media-libs/mesa[motif]
					( media-libs/mesa x11-libs/libGLw )
				)
			)
		)
		!python? ( ${TCL_DEPS} )
		!wxwidgets? ( ${TCL_DEPS} )
	)"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/flex
	sys-devel/gettext
	sys-devel/bison
	wxwidgets? ( dev-lang/swig )
	X? (
		x11-proto/xextproto
		x11-proto/xproto
	)"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-pkgconf.patch
	"${FILESDIR}"/${PN}-6.4.1-libav-0.8.patch
	"${FILESDIR}"/${PN}-6.4.2-ffmpeg-1.patch
	"${FILESDIR}"/${PN}-6.4.2-configure.patch
	"${FILESDIR}"/${PN}-6.4.2-libav-9.patch
)

REQUIRED_USE="
	motif? ( X )
	opengl? ( X )
	wxwidgets? ( X python )
"

pkg_setup() {
	local myblas

	# check correct gmath profiles (this must sadly die)
	if use gmath; then
		for d in $(eselect lapack show); do myblas=${d}; done
		if [[ -z "${myblas/reference/}" ]] && [[ -z "${myblas/atlas/}" ]]; then
			ewarn "You need to set lapack to atlas or reference. Do:"
			ewarn "   eselect lapack set <impl>"
			ewarn "where <impl> is atlas, threaded-atlas or reference"
			die "setup failed"
		fi
		for d in $(eselect blas show); do myblas=${d}; done
		if [[ -z "${myblas/reference/}" ]] && [[ -z "${myblas/atlas/}" ]]; then
			ewarn "You need to set blas to atlas or reference. Do:"
			ewarn "   eselect blas set <impl>"
			ewarn "where <impl> is atlas, threaded-atlas or reference"
			die "setup failed"
		fi
	fi

	if use python; then
		# only py2 is supported
		python_set_active_version 2
	fi
}

src_prepare() {
	use opengl || epatch "${FILESDIR}"/${PN}-6.4.0-html-nonviz.patch
	epatch ${PATCHES[@]}
	epatch_user
	eautoconf
}

src_configure() {
	local myconf TCL_LIBDIR

	if use X; then
		TCL_LIBDIR="/usr/$(get_libdir)/tcl8.5"
		myconf+="
			--with-tcltk-libs=${TCL_LIBDIR}
			$(use_with motif)
			$(use_with opengl)
			--with-x
			"

		use opengl && myconf+=" --with-tcltk"
		use motif && use opengl && myconf+=" --with-glw"
		use motif || myconf+=" --without-glw"

		if use wxwidgets; then
			WX_BUILD=yes
			WX_GTK_VER=2.8
			need-wxwidgets unicode
			myconf+="
				--without-tcltk
				--with-wxwidgets=${WX_CONFIG}
			"
		else
			WX_BUILD=no
			# use tcl gui if wxwidgets are disabled
			myconf+="
				--with-tcltk
				--without-wxwidgets
			"
		fi
	else
		myconf+="
			--without-glw
			--without-opengl
			--without-tcltk
			--without-wxwidgets
			--without-x
		"
	fi

	econf \
		--with-gdal=$(type -P gdal-config) \
		--with-curses \
		--with-proj \
		--with-proj-share="/usr/share/proj/" \
		--without-glw \
		--enable-shared \
		$(use_enable amd64 64bit) \
		$(use_enable ppc64 64bit) \
		$(use_with cairo) \
		$(use_with cxx) \
		$(use_with fftw) \
		$(use_with ffmpeg) \
		$(use_with gmath blas) \
		$(use_with gmath lapack) \
		$(use_with jpeg) \
		$(use_with mysql) \
		--with-mysql-includes=/usr/include/mysql \
		--with-mysql-libs=/usr/$(get_libdir)/mysql \
		$(use_with nls) \
		$(use_with odbc) \
		$(use_with png) \
		$(use_with postgres) \
		$(use_with python) \
		$(use_with readline) \
		$(use_with sqlite) \
		$(use_with tiff) \
		$(use_with truetype freetype) \
		--with-freetype-includes="/usr/include/freetype2/" \
		--enable-largefile \
		${myconf}
}

src_compile() {
	# we don't want to link against embeded mysql lib
	emake MYSQLDLIB=""
}

src_install() {
	emake DESTDIR="${D}" \
		INST_DIR="${D}"/usr/${MY_PM} \
		prefix="${D}"/usr BINDIR="${D}"/usr/bin \
		PREFIX="${D}"/usr/ \
		install

	pushd "${ED}"/usr/${MY_PM} &> /dev/null

	# fix docs
	dodoc AUTHORS CHANGES
	dohtml -r docs/html/*
	rm -rf docs/ || die
	rm -rf {AUTHORS,CHANGES,COPYING,GPL.TXT,REQUIREMENTS.html} || die

	# manuals
	dodir /usr/share/man/man1
	mv man/man1/* "${ED}"/usr/share/man/man1/ || die
	rm -rf man/ || die
	mv -vf "${ED}"/usr/share/man/man1/sql.1{,grass} || die #381599

	# translations
	if use nls; then
		dodir /usr/share/locale/
		mv locale/* "${ED}"/usr/share/locale/ || die
		rm -rf locale/ || die
		# pt_BR is broken
		mv "${ED}"/usr/share/locale/pt_br "${ED}"/usr/share/locale/pt_BR || die
	fi

	popd &> /dev/null

	# place libraries where they belong
	mv "${ED}"/usr/${MY_PM}/lib/ "${ED}"/usr/$(get_libdir)/ || die

	# place header files where they belong
	mv "${ED}"/usr/${MY_PM}/include/ "${ED}"/usr/include/ || die
	# make rules are not required on installed system
	rm -rf "${ED}"/usr/include/Make || die

	# mv remaining gisbase stuff to libdir
	mv "${ED}"/usr/${MY_PM} "${ED}"/usr/$(get_libdir) || die

	# set proper default window renderer
	if [[ ${WX_BUILD} == yes ]]; then
		sed -i \
			-e "1,\$s:^DEFAULT_GUI.*:DEFAULT_GUI=\"wxpython\":" \
			"${ED}"/usr/$(get_libdir)/${MY_PM}/etc/Init.sh || die
	fi

	# get proper folder for grass path in script
	sed -i \
		-e "1,\$s:^GISBASE.*:GISBASE=/usr/$(get_libdir)/${MY_PM}:" \
		"${ED}"usr/bin/${MY_PM} || die

	# get proper fonts path for fontcap
	sed -i \
		-e "s|${ED}/usr/${MY_PM}|${EPREFIX}usr/$(get_libdir)/${MY_PM}|" \
		"${ED}"/usr/$(get_libdir)/${MY_PM}/etc/fontcap || die

	if use X; then
		generate_files
		doicon gui/icons/${PN}-48x48.png
		domenu ${MY_PM}-grass.desktop
	fi

	# install .pc file so other apps know where to look for grass
	insinto /usr/$(get_libdir)/pkgconfig/
	doins grass.pc

	# fix weird +x on tcl scripts
	find "${D}" -name "*.tcl" -exec chmod +r-x '{}' \;
}

pkg_postinst() {
	if use X; then
		fdo-mime_desktop_database_update
		gnome2_icon_cache_update
	fi
}

pkg_postrm() {
	if use X; then
		fdo-mime_desktop_database_update
		gnome2_icon_cache_update
	fi
}

generate_files() {
	local GUI="-gui"
	[[ ${WX_BUILD} == yes ]] && GUI="-wxpython"

	cat <<-EOF > ${MY_PM}-grass.desktop
	[Desktop Entry]
	Encoding=UTF-8
	Version=1.0
	Name=Grass ${PV}
	Type=Application
	Comment=GRASS (Geographic Resources Analysis Support System), the original GIS.
	Exec=${TERM} -T Grass -e /usr/bin/${MY_PM} ${GUI}
	Path=
	Icon=${PN}-48x48.png
	Categories=Science;Education;
	Terminal=false
EOF
}
