# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/jsonrpclib/jsonrpclib-0_pre20110820-r1.ebuild,v 1.6 2015/06/07 09:32:05 maekke Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/joshmarshall/jsonrpclib.git"
	inherit git-2
else
	SRC_URI="mirror://gentoo/${P}.tar.bz2"
	KEYWORDS="amd64 arm x86"
fi

DESCRIPTION="python implementation of the JSON-RPC spec (1.0 and 2.0)"
HOMEPAGE="https://github.com/joshmarshall/jsonrpclib"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/simplejson"
