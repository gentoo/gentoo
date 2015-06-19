# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/thinkhdaps/thinkhdaps-0.2.1.ebuild,v 1.3 2010/10/06 20:31:47 maekke Exp $

EAPI=2

PYTHON_DEPEND=2

inherit base python

DESCRIPTION="A PyGTK based HDAPS monitor"
HOMEPAGE="http://thpani.at/projects/thinkhdaps/"
SRC_URI="http://thpani.at/media/downloads/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-python/libgnome-python:2
	dev-python/pygobject:2
	dev-python/pygtk:2"

DOCS=( AUTHORS NEWS )

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_configure() {
	econf --enable-desktop PYTHON=$(PYTHON -2 --absolute-path)
}
