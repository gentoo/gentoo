# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="tk?"
inherit cmake desktop flag-o-matic python-single-r1 xdg

DESCRIPTION="Desktop publishing (DTP) and layout program"
HOMEPAGE="https://www.scribus.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}-devel/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~ppc64 ~x86"
IUSE="+boost debug examples graphicsmagick hunspell +minimal osg +pdf scripts +templates tk"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	tk? ( scripts )"

# osg
# couple of third_party libs bundled
DEPEND="${PYTHON_DEPS}
	app-text/libmspub
	app-text/libqxp
	app-text/poppler:=
	dev-libs/hyphen
	dev-libs/icu:0=
	dev-libs/librevenge
	dev-libs/libxml2
	dev-qt/qtcore:5
	dev-qt/qtgui:5[-gles2-only]
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/harfbuzz:0=[icu]
	media-libs/lcms:2
	media-libs/libcdr
	media-libs/libfreehand
	media-libs/libjpeg-turbo:=
	media-libs/libpagemaker
	media-libs/libpng:0=
	media-libs/libvisio
	media-libs/libzmf
	media-libs/tiff:0
	net-print/cups
	sys-libs/zlib[minizip]
	x11-libs/cairo[X,svg]
	boost? ( dev-libs/boost:= )
	graphicsmagick? ( media-gfx/graphicsmagick:= )
	hunspell? ( app-text/hunspell:= )
	osg? ( dev-games/openscenegraph:= )
	pdf? ( app-text/podofo:0= )
	scripts? (
		$(python_gen_cond_dep '
			dev-python/pillow[tk?,${PYTHON_USEDEP}]
		')
	)
"
RDEPEND="${DEPEND}
	app-text/ghostscript-gpl
"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

PATCHES=(
	# non(?)-upstreamable
	"${FILESDIR}"/${PN}-1.5.3-fpic.patch
	"${FILESDIR}"/${PN}-1.5.6-docdir.patch
	"${FILESDIR}"/${PN}-1.5.8-findhyphen-1.patch
	"${FILESDIR}"/${PN}-1.5.6-findhyphen.patch
	"${FILESDIR}"/${PN}-1.5.8-poppler-22.2.0-1.patch
	"${FILESDIR}"/${PN}-1.5.8-poppler-22.2.0-2.patch
	"${FILESDIR}"/${PN}-1.5.8-poppler-22.03.0.patch # bug 834537
	"${FILESDIR}"/${PN}-1.5.8-poppler-22.04.0.patch # bug 843287
)

CMAKE_BUILD_TYPE="Release"

S="${WORKDIR}/${P}"

src_prepare() {
	cmake_src_prepare

	rm -r codegen/cheetah scribus/third_party/hyphen || die

	sed \
		-e "/^\s*unzip\.[ch]/d" \
		-e "/^\s*ioapi\.[ch]/d" \
		-i scribus/CMakeLists.txt Scribus.pro || die
	rm scribus/ioapi.[ch] || die

	sed \
		-e 's:\(${CMAKE_INSTALL_PREFIX}\):./\1:g' \
		-i resources/templates/CMakeLists.txt || die

	sed \
		-e "/^add_subdirectory(ui\/qml)/s/^/#DONT/" \
		-i scribus/CMakeLists.txt || die # nothing but a bogus Hello World test
}

src_configure() {
	# bug #550818
	append-cppflags -DHAVE_MEMRCHR

	local mycmakeargs=(
		-DHAVE_PYTHON=ON
		-DWANT_DISTROBUILD=ON
		-DWANT_CPP17=ON
		-DDOCDIR="${EPREFIX}"/usr/share/doc/${PF}/
		-DPython3_EXECUTABLE="${PYTHON}"
		-DWITH_BOOST=$(usex boost)
		-DWANT_DEBUG=$(usex debug)
		-DWANT_NOEXAMPLES=$(usex !examples)
		-DWANT_GRAPHICSMAGICK=$(usex graphicsmagick)
		-DWANT_HUNSPELL=$(usex hunspell)
		-DWANT_HEADERINSTALL=$(usex !minimal)
		-DWANT_NOOSG=$(usex !osg)
		-DWITH_PODOFO=$(usex pdf)
		-DWANT_NOTEMPLATES=$(usex !templates)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	if ! use tk; then
		rm "${ED}"/usr/share/scribus/scripts/{FontSample,CalendarWizard}.py || die
	fi
	if use scripts; then
		python_fix_shebang "${ED}"/usr/share/scribus/scripts
		python_optimize "${ED}"/usr/share/scribus/scripts
	else
		rm "${ED}"/usr/share/scribus/scripts/*.py || die
	fi

	mv "${ED}"/usr/share/doc/${PF}/{en,html} || die
	ln -sf html "${ED}"/usr/share/doc/${PF}/en || die

	# These files are parsed to populate the help/about window.
	cat >> "${T}"/COPYING <<- EOF || die
	${PN} is licensed under the "${LICENSE}".
	Please visit https://www.gnu.org/licenses/gpl-2.0.html for the complete license text.
	EOF
	dodoc "${T}"/COPYING
	docompress -x /usr/share/doc/${PF}/en /usr/share/doc/${PF}/{AUTHORS,TRANSLATION,LINKS,COPYING}

	local size
	for size in 16 32 128 256 512; do
		newicon -s $size resources/iconsets/artwork/icon_${size}x${size}.png scribus.png
	done
	newicon -s 64 resources/iconsets/artwork/icon_32x32@2x.png scribus.png
	doicon resources/iconsets/*/scribus.png
	domenu scribus.desktop
}
