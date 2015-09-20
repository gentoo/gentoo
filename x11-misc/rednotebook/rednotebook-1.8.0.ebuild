# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1

DESCRIPTION="A graphical journal with calendar, templates, tags, keyword searching, and export functionality"
HOMEPAGE="http://rednotebook.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="libyaml spell"

RDEPEND="
	dev-python/pyyaml[libyaml?,${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.13[${PYTHON_USEDEP}]
	>=dev-python/pywebkitgtk-1.1.5[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	spell? ( dev-python/gtkspell-python[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}"

src_prepare() {
	! use spell && epatch "${FILESDIR}/${PN}-1.6.5-disable-spell.patch"
}
