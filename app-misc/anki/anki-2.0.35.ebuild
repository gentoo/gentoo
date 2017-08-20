# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit eutils python-single-r1

DESCRIPTION="A spaced-repetition memory training program (flash cards)"
HOMEPAGE="http://ichi2.net/anki/"
SRC_URI="http://ankisrs.net/download/mirror/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="latex +recording +sound"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	 dev-python/PyQt4[X,svg,webkit]
	 >=dev-python/httplib2-0.7.4
	 dev-python/beautifulsoup:python-2
	 dev-python/send2trash
	 recording? ( media-sound/lame
				  >=dev-python/pyaudio-0.2.4 )
	 sound? ( media-video/mplayer )
	 latex? ( app-text/texlive
			  app-text/dvipng )"
DEPEND=""

pkg_setup(){
	python-single-r1_pkg_setup
}

src_prepare() {
	rm -r thirdparty || die
	sed -i -e "s/updates=True/updates=False/" \
		aqt/profiles.py || die
}

# Nothing to configure or compile
src_configure() {
	true;
}

src_compile() {
	true;
}

src_install() {
	doicon ${PN}.png
	domenu ${PN}.desktop
	doman ${PN}.1

	dodoc README README.development
	python_domodule aqt anki
	python_doscript anki/anki

	# Localization files go into the anki directory:
	python_moduleinto anki
	python_domodule locale
}
