# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="A PyGTK based HDAPS monitor"
HOMEPAGE="http://thpani.at/projects/thinkhdaps/"
SRC_URI="http://thpani.at/media/downloads/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/libgnome-python:2[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pygtk:2[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.1-fix-desktop-qa.patch
	"${FILESDIR}"/${PN}-0.2.1-fix-python-shebang.patch
)

src_configure() {
	econf --enable-desktop PYTHON="${EPYTHON}"
}
