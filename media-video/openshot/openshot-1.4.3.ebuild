# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/openshot/openshot-1.4.3.ebuild,v 1.3 2015/05/23 20:29:56 pacho Exp $

EAPI="5"

PYTHON_REQ_USE=xml
PYTHON_COMPAT=( python2_7 )

inherit versionator distutils-r1 python-r1 fdo-mime

DESCRIPTION="Free, open-source, non-linear video editor to create and edit videos and movies"
HOMEPAGE="http://www.openshotvideo.com"
SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+python +ffmpeg libav"
REQUIRED_USE="|| ( python ffmpeg )"

RDEPEND="
	dev-python/pygoocanvas[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	virtual/python-imaging[${PYTHON_USEDEP}]
	>=media-libs/mlt-0.8.2[ffmpeg,frei0r,gtk,melt,python,sdl,xml]
	ffmpeg? (
		libav? ( media-video/libav:=[encode,sdl,x264,mp3,theora] )
		!libav? ( media-video/ffmpeg:0=[encode,sdl,x264,mp3,theora] )
	)
	python? (
		dev-python/httplib2[${PYTHON_USEDEP}]
		dev-python/librsvg-python
	)
	x11-libs/gtk+:2
"

src_prepare() {
	sed -ie '/launcher/,+1d' setup.py || die
	sed -ie '/FAILED = /,$d' setup.py || die

	# Fix up launchers to not throw an error.
	sed -i 's/\(from \)\(openshot import main\)/\1openshot.\2/' bin/openshot || die
	sed -i 's/\(from \)\(openshot_render import main\)/\1openshot.\2/' bin/openshot-render || die
}

python_install() {
	distutils-r1_python_install
}

pkg_postinst() {
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}
