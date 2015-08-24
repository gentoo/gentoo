# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils qt4-build

DESCRIPTION="The GUI module for the Qt toolkit"
SRC_URI+=" https://dev.gentoo.org/~pesa/patches/${PN}-systemtrayicon-plugin-system.patch"

SLOT="4"
if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS="alpha arm hppa ia64 ppc ppc64 sparc"
else
	KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi

IUSE="+accessibility cups egl +glib gtkstyle mng nas nis qt3support tiff trace xinerama +xv"

REQUIRED_USE="
	gtkstyle? ( glib )
"

# cairo[-qt4] is needed because of bug 454066
RDEPEND="
	app-eselect/eselect-qtgraphicssystem
	~dev-qt/qtcore-${PV}[aqua=,debug=,glib=,qt3support=]
	~dev-qt/qtscript-${PV}[aqua=,debug=]
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/libpng:0=
	sys-libs/zlib
	virtual/jpeg:0
	!aqua? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXi
		x11-libs/libXrandr
		x11-libs/libXrender
		xinerama? ( x11-libs/libXinerama )
		xv? ( x11-libs/libXv )
	)
	cups? ( net-print/cups )
	egl? ( media-libs/mesa[egl] )
	glib? ( dev-libs/glib:2 )
	gtkstyle? (
		x11-libs/cairo[-qt4(-)]
		x11-libs/gtk+:2[aqua=]
	)
	mng? ( >=media-libs/libmng-1.0.9:= )
	nas? ( >=media-libs/nas-1.5 )
	tiff? ( media-libs/tiff:0 )
	!<dev-qt/qthelp-4.8.5:4
"
DEPEND="${RDEPEND}
	!aqua? (
		x11-proto/inputproto
		x11-proto/xextproto
		xinerama? ( x11-proto/xineramaproto )
		xv? ( x11-proto/videoproto )
	)
"
PDEPEND="qt3support? ( ~dev-qt/qt3support-${PV}[aqua=,debug=] )"

PATCHES=(
	"${DISTDIR}/${PN}-systemtrayicon-plugin-system.patch" # bug 503880
	"${FILESDIR}/${PN}-4.7.3-cups.patch" # bug 323257
	"${FILESDIR}/${PN}-4.8.5-cleanlooks-floating-point-exception.patch" # bug 507124
	"${FILESDIR}/${PN}-4.8.5-disable-gtk-theme-check.patch" # bug 491226
	"${FILESDIR}/${PN}-4.8.5-dont-crash-on-broken-GIF-images.patch" # bug 508984
	"${FILESDIR}/${PN}-4.8.5-keyboard-shortcuts.patch" # bug 477796
	"${FILESDIR}/${PN}-4.8.5-libjpeg-9.patch" # bug 480182
	"${FILESDIR}/${PN}-4.8.5-qclipboard-delay.patch" # bug 514968
	"${FILESDIR}/${PN}-4.8.5-CVE-2015-0295.patch" # bug 541972
)

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/gui
		src/scripttools
		src/plugins/imageformats/gif
		src/plugins/imageformats/ico
		src/plugins/imageformats/jpeg
		src/plugins/imageformats/tga
		src/plugins/inputmethods"

	QT4_EXTRACT_DIRECTORIES="
		examples/desktop/systray
		include
		src"

	use accessibility && QT4_TARGET_DIRECTORIES+=" src/plugins/accessible/widgets"
	use mng && QT4_TARGET_DIRECTORIES+=" src/plugins/imageformats/mng"
	use tiff && QT4_TARGET_DIRECTORIES+=" src/plugins/imageformats/tiff"
	use trace && QT4_TARGET_DIRECTORIES+=" src/plugins/graphicssystems/trace tools/qttracereplay"

	# mac version does not contain qtconfig?
	[[ ${CHOST} != *-darwin* ]] && QT4_TARGET_DIRECTORIES+=" tools/qtconfig"

	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES} ${QT4_EXTRACT_DIRECTORIES}"

	qt4-build_pkg_setup
}

src_prepare() {
	qt4-build_src_prepare

	# Add -xvideo to the list of accepted configure options
	sed -i -e 's:|-xinerama|:&-xvideo|:' configure || die
}

src_configure() {
	myconf="$(qt_use accessibility)
		$(qt_use cups)
		$(qt_use glib)
		$(qt_use mng libmng system)
		$(qt_use nas nas-sound system)
		$(qt_use nis)
		$(qt_use tiff libtiff system)
		$(qt_use egl)
		$(qt_use qt3support)
		$(qt_use gtkstyle)
		$(qt_use xinerama)
		$(qt_use xv xvideo)"

	myconf+="
		-system-libpng -system-libjpeg -system-zlib
		-no-sql-mysql -no-sql-psql -no-sql-ibase -no-sql-sqlite -no-sql-sqlite2 -no-sql-odbc
		-sm -xshape -xsync -xcursor -xfixes -xrandr -xrender -mitshm -xinput -xkb
		-fontconfig -no-svg -no-webkit -no-phonon -no-opengl"

	# bug 367045
	[[ ${CHOST} == *86*-apple-darwin* ]] && myconf+=" -no-ssse3"

	qt4-build_src_configure

	if use gtkstyle; then
		sed -i -e 's:-I/usr/include/qt4 ::' src/gui/Makefile || die "sed failed"
	fi

	sed -i -e 's:-I/usr/include/qt4/QtGui ::' src/gui/Makefile || die "sed failed"
}

src_install() {
	QCONFIG_ADD="
		mitshm tablet x11sm xcursor xfixes xinput xkb xrandr xrender xshape xsync
		fontconfig system-freetype gif png system-png jpeg system-jpeg
		$(usev accessibility)
		$(usev cups)
		$(use mng && echo system-mng)
		$(usev nas)
		$(usev nis)
		$(use tiff && echo system-tiff)
		$(usev xinerama)
		$(use xv && echo xvideo)"
	QCONFIG_REMOVE="no-freetype no-gif no-jpeg no-png no-gui"
	QCONFIG_DEFINE="$(use accessibility && echo QT_ACCESSIBILITY)
			$(use cups && echo QT_CUPS)
			$(use egl && echo QT_EGL)
			QT_FONTCONFIG QT_FREETYPE
			$(use gtkstyle && echo QT_STYLE_GTK)
			QT_IMAGEFORMAT_JPEG QT_IMAGEFORMAT_PNG
			$(use mng && echo QT_IMAGEFORMAT_MNG)
			$(use nas && echo QT_NAS)
			$(use nis && echo QT_NIS)
			$(use tiff && echo QT_IMAGEFORMAT_TIFF)
			QT_SESSIONMANAGER QT_SHAPE QT_TABLET QT_XCURSOR QT_XFIXES
			$(use xinerama && echo QT_XINERAMA)
			QT_XINPUT QT_XKB QT_XRANDR QT_XRENDER QT_XSYNC
			$(use xv && echo QT_XVIDEO)"

	qt4-build_src_install

	# install private headers
	if use aqua && [[ ${CHOST##*-darwin} -ge 9 ]]; then
		insinto "${QTLIBDIR#${EPREFIX}}"/QtGui.framework/Headers/private/
	else
		insinto "${QTHEADERDIR#${EPREFIX}}"/QtGui/private
	fi
	find "${S}"/src/gui -type f -name '*_p.h' -exec doins {} +

	if use aqua && [[ ${CHOST##*-darwin} -ge 9 ]]; then
		# rerun to get links to headers right
		fix_includes
	fi

	# touch the available graphics systems
	dodir /usr/share/qt4/graphicssystems
	echo "default" > "${ED}"/usr/share/qt4/graphicssystems/raster || die
	echo "" > "${ED}"/usr/share/qt4/graphicssystems/native || die

	newicon tools/qtconfig/images/appicon.png qtconfig.png
	make_desktop_entry qtconfig 'Qt Configuration Tool' qtconfig 'Qt;Settings;DesktopSettings'

	# bug 388551
	if use gtkstyle; then
		local tempfile=${T}/${PN}${SLOT}.sh
		cat <<-EOF > "${tempfile}"
		export GTK2_RC_FILES=\${HOME}/.gtkrc-2.0
		EOF
		insinto /etc/profile.d
		doins "${tempfile}"
	fi
}

pkg_postinst() {
	qt4-build_pkg_postinst

	# raster is the default graphicssystem, set it on first install
	eselect qtgraphicssystem set raster --use-old
}
