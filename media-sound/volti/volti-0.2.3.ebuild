# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="GTK+ application for controlling audio volume from system tray/notification area"
HOMEPAGE="http://code.google.com/p/volti/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="libnotify X"

RDEPEND=">=dev-python/pygtk-2.16
	>=dev-python/pyalsaaudio-0.6
	dev-python/dbus-python
	X? ( >=dev-python/python-xlib-0.15_rc1 )
	libnotify? ( x11-libs/libnotify )"
DEPEND=""

DOCS="AUTHORS ChangeLog README"
