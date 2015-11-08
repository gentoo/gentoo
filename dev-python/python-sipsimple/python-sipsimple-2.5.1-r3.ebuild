# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="SIP SIMPLE client SDK is a Software Development Kit"
HOMEPAGE="http://sipsimpleclient.org"
SRC_URI="http://download.ag-projects.com/SipClient/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="libressl"

KEYWORDS="~amd64 ~x86"

CDEPEND="
	dev-db/sqlite:3
	!libressl? ( dev-libs/openssl:0[-bindist] )
	libressl? ( dev-libs/libressl )
	dev-python/python-application[${PYTHON_USEDEP}]
	media-libs/alsa-lib
	media-libs/libv4l
	media-libs/libvpx
	sys-apps/util-linux
	virtual/ffmpeg
"
RDEPEND="${CDEPEND}
	virtual/dnspython[${PYTHON_USEDEP}]
	dev-python/python-cjson[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/python-eventlib[${PYTHON_USEDEP}]
	dev-python/greenlet[${PYTHON_USEDEP}]
	dev-python/python-gnutls[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/python-msrplib[${PYTHON_USEDEP}]
	dev-python/python-xcaplib[${PYTHON_USEDEP}]
	dev-python/twisted-core[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
"
DEPEND="${CDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	virtual/pkgconfig
"
