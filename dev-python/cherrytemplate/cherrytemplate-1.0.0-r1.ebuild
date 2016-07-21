# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="CherryTemplate"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Easy and powerful templating module for Python"
HOMEPAGE="http://cherrytemplate.python-hosting.com/"
SRC_URI="mirror://sourceforge/cherrypy/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ia64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"
