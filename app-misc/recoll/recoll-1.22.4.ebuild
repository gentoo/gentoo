# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit eutils linux-info python-single-r1 qmake-utils

DESCRIPTION="A personal full text search package"
HOMEPAGE="http://www.lesbonscomptes.com/recoll/"
SRC_URI="http://www.lesbonscomptes.com/recoll/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

IUSE="camelcase doc +inotify qt4 qt5 session +spell"
REQUIRED_USE="session? ( inotify ) ${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="
	dev-libs/xapian:=
	sys-libs/zlib
	virtual/libiconv
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwebkit:5
	)
	!qt5? ( qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	) )
	session? (
		inotify? ( x11-libs/libSM x11-libs/libICE )
	)
	spell? ( app-text/aspell )
	${PYTHON_DEPS}
"
DEPEND="${COMMON_DEPEND}
	qt5? ( dev-qt/linguist-tools:5 )
"
RDEPEND="${COMMON_DEPEND}
	app-arch/unzip
	sys-apps/sed
	virtual/awk
"

pkg_setup() {
	if has_version "<app-misc/recoll-1.20"; then
		einfo "Installing ${PV} over an 1.19 index is possible,"
		einfo "but there have been small changes in the way"
		einfo "compound words are indexed. So it is best to reset"
		einfo "the index. The best method to reset the index is to"
		einfo "quit all recoll programs and delete the index directory"
		einfo "rm -rf ~/.recoll/xapiandb, then start recoll or recollindex."
	fi
	if use inotify; then
		CONFIG_CHECK="~INOTIFY_USER"
		check_extra_config
	fi
	python-single-r1_pkg_setup
}

src_prepare() {
	python_fix_shebang filters
	default
}

src_configure() {
	local qtconf
	if use qt4 || use qt5; then
		qtconf="--enable-qtgui"
		if use qt5; then
			export QT_SELECT=qt5
			qtconf+=" --enable-webkit"
		elif use qt4; then
			export QT_SELECT=qt4
			qtconf+=" --disable-webkit"
		fi
	else
		qtconf="--disable-qtgui --disable-webkit"
	fi

	econf \
		$(use_enable camelcase) \
		$(use_enable session x11mon) \
		$(use_with inotify) \
		$(use_with spell aspell) \
		${qtconf} \
		--without-fam \
		--enable-recollq
}

src_install() {
	emake STRIP="$(type -P true)" DESTDIR="${D}" install
	prune_libtool_files

	# html docs should be placed in /usr/share/doc/${PN}/html
	use doc && dodoc "${ED}"/usr/share/recoll/doc/*
	rm -r "${ED}/usr/share/recoll/doc" || die
}

pkg_postinst() {
	einfo "In order to extract the full functionality of "
	einfo "recoll, the following packages should be installed "
	einfo "to get the corresponding document support."

	optfeature "XML based documents support"    "dev-libs/libxslt[python] dev-libs/libxml2[python]"
	optfeature "PDF files support"              app-text/poppler
	optfeature "PDF files with OCR support"     app-text/tesseract
	optfeature "MS Word files support"          app-text/antiword
	optfeature "Wordperfect files support"      "app-text/libwpd[tools]"
	optfeature "Lyx files support"              app-office/lyx
	optfeature "CHM files support"              dev-python/pychm
	optfeature "GNU Info files support"         sys-apps/texinfo
	optfeature "RAR archives support"           dev-python/rarfile
	optfeature "7zip archives support"          dev-python/pylzma
	optfeature "iCalendar files support"        dev-python/icalendar
	optfeature "Postscript files support"       app-text/pstotext
	optfeature "RTF files support"              app-text/unrtf
	optfeature "TeX files support"              dev-text/detex
	optfeature "DVI files support"              virtual/tex-base
	optfeature "DJVU files support"             app-text/djvu
	optfeature "tags in audio files support"    media-libs/mutagen
	optfeature "tags in image files support"    media-libs/exiftool
	optfeature "Midi karaoke files support"     dev-python/chardet
}
