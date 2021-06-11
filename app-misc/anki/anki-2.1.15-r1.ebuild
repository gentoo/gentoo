# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE="sqlite"

inherit desktop optfeature python-single-r1 xdg

DESCRIPTION="A spaced-repetition memory training program (flash cards)"
HOMEPAGE="https://apps.ankiweb.net"
SRC_URI="https://apps.ankiweb.net/downloads/archive/${P}-source.tgz -> ${P}.tgz"

LICENSE="AGPL-3+ BSD MIT GPL-3+ CC-BY-SA-3.0 Apache-2.0 CC-BY-2.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/PyQt5-5.12[gui,svg,widgets,${PYTHON_MULTI_USEDEP}]
		>=dev-python/PyQtWebEngine-5.12[${PYTHON_MULTI_USEDEP}]
		>=dev-python/httplib2-0.7.4[${PYTHON_MULTI_USEDEP}]
		dev-python/beautifulsoup:4[${PYTHON_MULTI_USEDEP}]
		dev-python/decorator[${PYTHON_MULTI_USEDEP}]
		dev-python/jsonschema[${PYTHON_MULTI_USEDEP}]
		dev-python/markdown[${PYTHON_MULTI_USEDEP}]
		dev-python/requests[${PYTHON_MULTI_USEDEP}]
		dev-python/send2trash[${PYTHON_MULTI_USEDEP}]
	')
"
BDEPEND="test? (
	${RDEPEND}
	$(python_gen_cond_dep '
		dev-python/nose[${PYTHON_MULTI_USEDEP}]
		dev-python/mock[${PYTHON_MULTI_USEDEP}]
		')
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.0_beta25-web-folder.patch
	"${FILESDIR}"/${PN}-2.1.15-mpv-args.patch
	"${FILESDIR}"/${PN}-2.1.15-unescape.patch
)

src_prepare() {
	default
	sed -i -e "s/updates=True/updates=False/" \
		aqt/profiles.py || die
}

src_compile() {
	:;
}

src_test() {
	sed -e "s:nose=nosetests$:nose=\"${EPYTHON} ${BROOT}/usr/bin/nosetests\":" \
		-i tools/tests.sh || die
	sed -e "s:nose=nosetests3$:nose=\"${EPYTHON} ${BROOT}/usr/bin/nosetests3\":" \
		-i tools/tests.sh || die
	sed -e "s:which nosetests3:which ${BROOT}/usr/bin/nosetests3:" \
		-i tools/tests.sh || die
	./tools/tests.sh || die
}

src_install() {
	doicon ${PN}.png
	domenu ${PN}.desktop
	doman ${PN}.1

	dodoc README.md README.development
	python_domodule aqt anki
	python_newscript runanki anki

	# Localization files go into the anki directory:
	python_moduleinto anki
	python_domodule locale

	# not sure if this is correct, but
	# site-packages/aqt/mediasrv.py wants the directory
	insinto /usr/share/anki
	doins -r web
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "LaTeX in cards" "app-text/texlive app-text/dvipng"
	optfeature "Record sound" "dev-python/pyaudio media-sound/lame"
	optfeature "Playback sound" media-video/mpv media-video/mplayer
}
