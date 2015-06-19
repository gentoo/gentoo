# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sqlitecachec/sqlitecachec-1.1.4-r1.ebuild,v 1.8 2015/04/08 08:05:21 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 pypy )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

MY_P="yum-metadata-parser-${PV}"

DESCRIPTION="sqlite cacher for python applications"
HOMEPAGE="http://yum.baseurl.org/"
SRC_URI="http://yum.baseurl.org/download/yum-metadata-parser/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

# glib and libxml2 are used via an extension module written in C.
# No need to add PYTHON_USEDEP here.
RDEPEND="dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"
