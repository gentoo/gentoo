# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit linux-info optfeature python-single-r1 qmake-utils systemd

DESCRIPTION="Personal full text search package"
HOMEPAGE="https://www.lesbonscomptes.com/recoll/"
SRC_URI="https://www.lesbonscomptes.com/recoll/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="camelcase chm +inotify qt5 session +spell systemd webengine"
REQUIRED_USE="
	session? ( inotify )
	webengine? ( qt5 )
	${PYTHON_REQUIRED_USE}
"

DEPEND="
	dev-libs/xapian:=
	sys-libs/zlib:=
	virtual/libiconv
	chm? (
		dev-libs/chmlib
		dev-python/pychm
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
		webengine? ( dev-qt/qtwebengine:5[widgets] )
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
	qt5? ( dev-qt/linguist-tools:5 )
"

RDEPEND="
	${DEPEND}
	app-arch/unzip
"

pkg_pretend() {
	if has_version "<app-misc/recoll-1.20"; then
		elog "Installing ${PV} over an 1.19 index is possible,"
		elog "but there have been small changes in the way"
		elog "compound words are indexed. So it is best to reset"
		elog "the index. The best method to reset the index is to"
		elog "quit all recoll programs and delete the index directory"
		elog "rm -rf ~/.recoll/xapiandb, then start recoll or recollindex."
	fi
}

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
	use qt5 && export QMAKE="$(qt5_get_bindir)/qmake"

	local myeconfargs=(
		$(use_enable camelcase)
		$(use_enable chm python-chm)
		$(use_enable session x11mon)
		$(use_enable qt5 qtgui)
		$(use_enable webengine)
		$(use_with inotify)
		$(use_with spell aspell)
		$(use_with systemd)
		--with-system-unit-dir="$(systemd_get_systemunitdir)"
		--with-user-unit-dir="$(systemd_get_userunitdir)"
		--disable-webkit
		--without-fam
		--enable-recollq
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	emake STRIP="$(type -P true || die)" DESTDIR="${D}" install
	python_optimize

	# html docs should be placed in /usr/share/doc/${PN}/html
	dodoc -r "${ED}"/usr/share/recoll/doc/.
	rm -r "${ED}/usr/share/recoll/doc" || die
	find "${D}" -name '*.la' -delete || die
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
	optfeature "TeX files support" dev-text/detex
	optfeature "DVI files support" virtual/tex-base
	optfeature "DJVU files support" app-text/djvu
	optfeature "tags in audio files support" media-libs/mutagen
	optfeature "tags in image files support" media-libs/exiftool
	optfeature "Midi karaoke files support" dev-python/chardet
}
