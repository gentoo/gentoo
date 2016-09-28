# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python3_4 )

DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="Genealogical Research and Analysis Management Programming System"
HOMEPAGE="https://gramps-project.org/"
SRC_URI="https://github.com/gramps-project/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+reports +exif spell"

RDEPEND="
	dev-python/bsddb3[${PYTHON_USEDEP}]
	>=dev-python/pygobject-3.12:3[${PYTHON_USEDEP}]
	dev-python/pyicu[${PYTHON_USEDEP}]
	gnome-base/librsvg:2
	x11-libs/cairo
	>x11-libs/gtk+-3.14.8:3
	x11-libs/pango[introspection]
	x11-misc/xdg-utils
	reports? ( media-gfx/graphviz )
	exif? ( >=media-libs/gexiv2-0.5[${PYTHON_USEDEP},introspection] )
	spell? (
		app-text/gtkspell[introspection]
		dev-python/gtkspell-python
	)
"

PATCHES=(
	"${FILESDIR}/${P}-resourcepath.patch"
	"${FILESDIR}/${P}-versioned_doc_dir.patch"
)
