# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit linux-info optfeature python-single-r1 qmake-utils meson systemd

DESCRIPTION="Personal full text search package"
HOMEPAGE="https://www.recoll.org"
SRC_URI="https://www.recoll.org/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

IUSE="camelcase chm +inotify qt6 session +spell systemd webengine"
REQUIRED_USE="
	session? ( inotify )
	webengine? ( qt6 )
	${PYTHON_REQUIRED_USE}
"

DEPEND="
	dev-libs/libxml2:=
	dev-libs/libxslt
	dev-libs/xapian:=
	sys-libs/zlib
	virtual/libiconv
	chm? (
		dev-libs/chmlib
		dev-python/pychm
	)
	qt6? (
		dev-qt/qtbase:6[gui,network,widgets]
		webengine? ( dev-qt/qtwebengine:6[widgets] )
	)
	session? (
		inotify? (
			x11-libs/libSM
			x11-libs/libICE
			x11-libs/libX11
		)
	)
	spell? ( app-text/aspell )
	systemd? ( sys-apps/systemd )
	${PYTHON_DEPS}
"

BDEPEND="
	qt6? ( dev-qt/qttools:6[linguist] )
"

RDEPEND="
	${DEPEND}
	app-arch/unzip
"

pkg_setup() {
	if use inotify; then
		local CONFIG_CHECK="~INOTIFY_USER"
		check_extra_config
	fi
	python-single-r1_pkg_setup
}

src_prepare() {
	default
	python_fix_shebang filters
}

src_configure() {
	use qt6 && export QMAKE="$(qt6_get_bindir)/qmake"

	local emesonargs=(
		$(meson_use camelcase)
		$(meson_use chm python-chm)
		$(meson_use inotify)
		$(meson_use qt6 qtgui)
		$(meson_use session x11mon)
		$(meson_use spell aspell)
		$(meson_use spell python-aspell)
		$(meson_use systemd)
		$(meson_use webengine)
		-Dappimage=false
		-Dfam=false
		-Drecollq=true
		-Dwebkit=false
		-Dsystemd-system-unit-dir="$(systemd_get_systemunitdir)"
		-Dsystemd-user-unit-dir="$(systemd_get_userunitdir)"
	)

	use qt6 && emesonargs+=( $(usex webengine "-Dwebpreview=true" "-Dwebpreview=false") )

	meson_src_configure
}

src_install() {
	meson_install
	rm -rf "${D}/$(python_get_sitedir)"/*.egg-info || die
	python_optimize

	# html docs should be placed in /usr/share/doc/${PN}/html
	rm -r "${ED}/usr/share/${PN}/doc" || die
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	optfeature "XML based documents support" "dev-libs/libxslt[python] dev-libs/libxml2[python]"
	optfeature "PDF files support" app-text/poppler
	optfeature "PDF files with OCR support" app-text/tesseract
	optfeature "MS Word files support" app-text/antiword
	optfeature "Wordperfect files support" "app-text/libwpd[tools]"
	optfeature "Lyx files support" app-office/lyx
	optfeature "GNU Info files support" sys-apps/texinfo
	optfeature "RAR archives support" dev-python/rarfile
	optfeature "7zip archives support" dev-python/pylzma
	optfeature "iCalendar files support" dev-python/icalendar
	optfeature "Postscript files support" app-text/pstotext
	optfeature "RTF files support" app-text/unrtf
	optfeature "TeX files support" virtual/tex-base
	optfeature "DVI files support" virtual/tex-base
	optfeature "DJVU files support" app-text/djvu
	optfeature "tags in audio files support" media-libs/mutagen
	optfeature "tags in image files support" media-libs/exiftool
	optfeature "Midi karaoke files support" dev-python/chardet
}
