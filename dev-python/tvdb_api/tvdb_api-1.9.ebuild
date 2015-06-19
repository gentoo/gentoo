# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/tvdb_api/tvdb_api-1.9.ebuild,v 1.2 2015/01/08 07:38:34 vapier Exp $

EAPI=5

PYTHON_COMPAT="python2_7"
inherit distutils-r1 vcs-snapshot

DESCRIPTION="Python interface to thetvdb.com API"
HOMEPAGE="http://github.com/dbr/tvdb_api"
SRC_URI="https://github.com/dbr/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND=""
