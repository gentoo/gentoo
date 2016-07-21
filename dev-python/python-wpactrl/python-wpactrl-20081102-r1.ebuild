# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A Python extension for wpa_supplicant/hostapd control interface access"
HOMEPAGE="http://projects.otaku42.de/wiki/PythonWpaCtrl"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="|| ( GPL-2 BSD )"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

DEPEND=""
RDEPEND=""
