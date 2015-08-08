# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils python-r1

DESCRIPTION="The tree notes organizer"
HOMEPAGE="http://jenyay.net/Outwiker/English"
SRC_URI="https://github.com/Jenyay/${PN}/archive/stable_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-python/pywebkitgtk[${PYTHON_USEDEP}]
	dev-python/wxpython[${PYTHON_USEDEP}]
	virtual/python-imaging[${PYTHON_USEDEP}]
	x11-misc/xdg-utils
	x11-themes/hicolor-icon-theme
"

S="${WORKDIR}/${PN}-stable_${PV}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	# fix desktop file
	sed -i -e 's/Application;//' outwiker.desktop || die 'sed on outwiker.desktop failed'

	epatch_user
}
