# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python3_4 python3_5 python3_6 )
PYTHON_REQ_USE="sqlite"

inherit eutils python-single-r1

DESCRIPTION="A spaced-repetition memory training program (flash cards)"
HOMEPAGE="https://apps.ankiweb.net"

MY_P="${P/_/}"
SRC_URI="https://apps.ankiweb.net/downloads/beta/${MY_P}-source.tgz -> ${P}.tgz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="latex +recording +sound"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/PyQt5[gui,svg,webkit,${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.7.4[${PYTHON_USEDEP}]
	dev-python/beautifulsoup[${PYTHON_USEDEP}]
	dev-python/send2trash[${PYTHON_USEDEP}]
	recording? (
		media-sound/lame
		>=dev-python/pyaudio-0.2.4[${PYTHON_USEDEP}]
	)
	sound? ( media-video/mplayer )
	latex? (
		app-text/texlive
		app-text/dvipng
	)"
DEPEND=""

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	sed -i -e "s/updates=True/updates=False/" \
		aqt/profiles.py || die
}

# Nothing to configure or compile
src_configure() {
	:;
}

src_compile() {
	:;
}

src_install() {
	cp tools/runanki.system tools/anki
	doicon ${PN}.png
	domenu ${PN}.desktop
	doman ${PN}.1

	dodoc README.md README.development
	python_domodule aqt anki
	python_doscript tools/anki

	# Localization files go into the anki directory:
	python_moduleinto anki
	python_domodule locale
}
