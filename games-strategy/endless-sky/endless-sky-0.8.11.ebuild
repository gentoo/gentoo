# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit games scons-utils

DESCRIPTION="Space exploration, trading and combat game in the tradition of Terminal Velocity."
HOMEPAGE="https://endless-sky.github.io"
SRC_URI="https://github.com/tomboy-64/endless-sky/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="media-libs/glew
	media-libs/libsdl2
	media-libs/libjpeg-turbo
	media-libs/libpng:*
	media-libs/openal
	virtual/opengl"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i 's/"-std=c++0x", "-O3", "-Wall"/"-std=c++0x", "-Wall"/' SConstruct || die
	sed -i 's#"Directory to install under", "/usr/local", PathVariable.PathIsDirCreate#"Directory to install under", "'"${D}/usr/"'", PathVariable.PathIsDirCreate#' SConstruct || die
#	sed -i 's#"Destination root directory", "", PathVariable.PathAccept))#"Destination root directory", "'"${PREFIX}/usr/"'", PathVariable.PathAccept))#' SConstruct || die
	sed -i 's/"-std=c++0x", "-O3", "-Wall"/"-std=c++0x", "-Wall"/' SConstruct || die
}

src_compile() {
	escons
}

src_install() {
	scons install
	prepgamesdirs
}
