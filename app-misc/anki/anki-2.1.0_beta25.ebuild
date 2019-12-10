# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="sqlite"

inherit eutils python-single-r1 xdg

DESCRIPTION="A spaced-repetition memory training program (flash cards)"
HOMEPAGE="https://apps.ankiweb.net"

MY_P="${P/_/}"
SRC_URI="https://apps.ankiweb.net/downloads/beta/${MY_P}-source.tgz -> ${P}.tgz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="latex +recording +sound test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/PyQt5[gui,svg,webkit,${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.7.4[${PYTHON_USEDEP}]
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/send2trash[${PYTHON_USEDEP}]
	recording? (
		media-sound/lame
		>=dev-python/pyaudio-0.2.4[${PYTHON_USEDEP}]
	)
	sound? ( media-video/mplayer )
	latex? (
		app-text/texlive
		app-text/dvipng
	)
"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

PATCHES=( "${FILESDIR}"/${P}-web-folder.patch )

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	default
	sed -i -e "s/updates=True/updates=False/" \
		aqt/profiles.py || die
}

src_compile() {
	:;
}

src_test() {
	sed -e "s:nosetests:${EPYTHON} ${EROOT}usr/bin/nosetests:" \
		-i tools/tests.sh || die
	./tools/tests.sh || die
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

	# not sure if this is correct, but
	# site-packages/aqt/mediasrv.py wants the directory
	insinto /usr/share/anki
	doins -r web
}
