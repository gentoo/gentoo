# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT="python2_7"
inherit distutils-r1 vcs-snapshot

DESCRIPTION="Python interface to thetvdb.com API"
HOMEPAGE="https://github.com/dbr/tvdb_api"
SRC_URI="https://github.com/dbr/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND=""
