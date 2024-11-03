# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="tk?"
inherit cmake desktop flag-o-matic optfeature python-single-r1 xdg

DESCRIPTION="Desktop publishing (DTP) and layout program"
HOMEPAGE="https://www.scribus.net/"

if [[ "${PV}" == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/scribusproject/scribus"
	EGIT_BRANCH="Version16x"
	inherit git-r3
else
	SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${P}.tar.xz"
	S="${WORKDIR}/${P}"
	KEYWORDS="amd64 ppc ppc64 x86"
fi

LICENSE="GPL-2"
SLOT="$(ver_cut 1-2)"
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
	dev-qt/qtgui:5[-gles2-only,X]
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
	media-libs/tiff:=
	net-print/cups
	sys-libs/zlib[minizip]
	x11-libs/cairo[X,svg(+)]
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
	"${FILESDIR}"/${PN}-1.5.8-cmake.patch # bug 886251
	"${FILESDIR}"/${PN}-1.5.3-fpic.patch
	"${FILESDIR}"/${PN}-1.6.1-findhyphen.patch
	"${FILESDIR}"/${PN}-1.7.0-fix-icon-version.patch
	"${FILESDIR}"/${P}-poppler-24.{10,11}.0.patch # bug 941932
)

src_prepare() {
	cmake_src_prepare
	cmake_run_in scribus cmake_comment_add_subdirectory ui/qml

	# for safety remove files that we patched out
	rm -r scribus/third_party/hyphen || die
}

src_configure() {
	# bug #550818
	append-cppflags -DHAVE_MEMRCHR

	local mycmakeargs=(
		-DTAG_VERSION="-${SLOT}"
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
		rm "${ED}"/usr/share/scribus-${SLOT}/scripts/{FontSample,CalendarWizard}.py || die
	fi
	if use scripts; then
		python_fix_shebang "${ED}"/usr/share/scribus-${SLOT}/scripts
		python_optimize "${ED}"/usr/share/scribus-${SLOT}/scripts
	else
		rm "${ED}"/usr/share/scribus-${SLOT}/scripts/*.py || die
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
		newicon -s $size resources/iconsets/artwork/icon_${size}x${size}.png scribus-${SLOT}.png
	done
	newicon -s 64 resources/iconsets/artwork/icon_32x32@2x.png scribus-${SLOT}.png
	newicon resources/iconsets/1_5_1/scribus.png scribus-${SLOT}.png
	newmenu scribus.desktop scribus-${SLOT}.desktop
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "MS Word .doc file import filter support" app-text/antiword
}
