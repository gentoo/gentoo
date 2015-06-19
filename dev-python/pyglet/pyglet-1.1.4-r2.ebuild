# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyglet/pyglet-1.1.4-r2.ebuild,v 1.6 2015/05/28 14:11:54 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Cross-platform windowing and multimedia library for Python"
HOMEPAGE="http://www.pyglet.org/"
SRC_URI="http://pyglet.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="alsa doc examples gtk +openal"

RDEPEND="
	virtual/opengl
	alsa? ( media-libs/alsa-lib[alisp] )
	gtk? ( x11-libs/gtk+:2 )
	openal? ( media-libs/openal )"
DEPEND="${RDEPEND}"
#	ffmpeg? ( media-libs/avbin-bin )

DOCS="NOTICE"

python_install_all() {
	use doc && HTML_DOCS=( doc/html/. )
	use examples && EXAMPLES=( examples )
	distutils-r1_python_install_all
}
