# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
inherit optfeature python-r1

DESCRIPTION="Stylish way of giving presentations with Python"
HOMEPAGE="http://impressive.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN^}/${PV/_/-}/${PN^}-${PV/_/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	app-text/mupdf
	dev-python/pygame[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	x11-apps/xrandr
	|| (
		media-fonts/dejavu
		media-fonts/corefonts
	)
"

DOCS=( changelog.txt demo.pdf )
HTML_DOCS=( impressive.html )

S="${WORKDIR}/${PN^}-${PV/_/-}"

src_install() {
	default
	python_foreach_impl python_doscript ${PN}.py
	doman impressive.1
}

pkg_postinst() {
	optfeature "starting web or e-mail hyperlinks from PDF documents" x11-misc/xdg-utils
	optfeature "sound and video playback" media-video/ffmpeg
	optfeature "sound and video playback" media-video/mplayer
	optfeature "extraction of PDF page titles" app-text/pdftk
}
