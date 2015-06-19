# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/tvnamer/tvnamer-2.3.ebuild,v 1.2 2015/01/08 07:38:34 vapier Exp $

EAPI=5

PYTHON_COMPAT="python2_7"
inherit distutils-r1

DESCRIPTION="Automatic TV episode file renamer, data from thetvdb.com"
HOMEPAGE="http://github.com/dbr/tvnamer"
SRC_URI="mirror://pypi/t/${PN}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-python/tvdb_api"
DEPEND="${DEPEND}
	dev-python/setuptools
"
