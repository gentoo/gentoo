# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
PLOCALES="cs_CZ es_MX fr gl it pl_PL pt_BR ro_RO ru si_LK uk zh_CN zh_TW"

inherit python-single-r1 l10n

DESCRIPTION="Extracts audio tracks from audio CD image to separate tracks"
HOMEPAGE="https://code.google.com/p/flacon/"
SRC_URI="https://flacon.googlecode.com/files/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="flac mac mp3 mp4 ogg replaygain tta wavpack"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/PyQt4[X,${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	media-sound/shntool[mac?]
	flac? ( media-libs/flac )
	mac? ( media-sound/mac )
	mp3? ( media-sound/lame )
	mp4? ( media-libs/faac )
	ogg? ( media-sound/vorbis-tools )
	tta? ( media-sound/ttaenc )
	wavpack? ( media-sound/wavpack )
	replaygain? (
		mp3? ( media-sound/mp3gain )
		ogg? ( media-sound/vorbisgain )
	)
"
DEPEND="${RDEPEND}"

src_prepare() {
	my_rm_loc() {
		rm -v "translations/${PN}_${1}."{ts,qm} || die
	}

	l10n_find_plocales_changes "translations" "${PN}_" '.qm'
	l10n_for_each_disabled_locale_do my_rm_loc

	if [ -z "$(l10n_get_locales)" ]; then
		sed -e '/install .*translations/d' -i Makefile || die
	fi

	python_fix_shebang .

	sed -e '/cd $(INST_DIR) && python -mcompileall ./d' -i Makefile || die

	# do not use /tmp/ for tests
	sed -e "s,/tmp/,${T}/," -i Makefile tests/flacon_tests.py || die
}

src_compile() { :; }

src_test() {
	"${PYTHON}" tests/flacon_tests.py --verbose || die "Testing failed with ${PYTHON}"
}

src_install() {
	default

	python_optimize "${ED}"/usr/share/${PN}
}
