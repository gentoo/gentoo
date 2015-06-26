# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyglet/pyglet-1.2.3.ebuild,v 1.1 2015/06/26 12:44:16 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1 virtualx

DESCRIPTION="Cross-platform windowing and multimedia library for Python"
HOMEPAGE="http://www.pyglet.org/"
SRC_URI="
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	http://pyglet.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="alsa examples gtk +openal"

RDEPEND="
	virtual/opengl
	alsa? ( media-libs/alsa-lib[alisp] )
	gtk? ( x11-libs/gtk+:2 )
	openal? ( media-libs/openal )"
DEPEND="${RDEPEND}"
#	ffmpeg? ( media-libs/avbin-bin )

# pyglet.gl.glx_info.GLXInfoException: pyglet requires an X server with GLX
RESTRICT=test

python_test() {
	python_is_python3 && return
	VIRTUALX_COMMAND="${PYTHON}"
	virtualmake tests/test.py
}

python_install_all() {
	DOCS=( NOTICE )
	use examples && EXAMPLES=( examples )
	distutils-r1_python_install_all
}
