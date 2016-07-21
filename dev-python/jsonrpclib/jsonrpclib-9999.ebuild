# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/joshmarshall/jsonrpclib.git"
	inherit git-2
else
	SRC_URI="https://github.com/joshmarshall/jsonrpclib/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~mips ~x86"
fi

DESCRIPTION="python implementation of the JSON-RPC spec (1.0 and 2.0)"
HOMEPAGE="https://github.com/joshmarshall/jsonrpclib"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/simplejson"
