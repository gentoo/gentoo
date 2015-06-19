# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyds/pyds-0.7.3-r1.ebuild,v 1.3 2015/04/08 08:05:26 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P="PyDS-${PV}"

DESCRIPTION="Python Desktop Server"
HOMEPAGE="http://pyds.muensterland.org/"
SRC_URI="http://simon.bofh.ms/~gb/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="app-text/silvercity
	>=dev-db/metakit-2.4.9.2[python,${PYTHON_USEDEP}]
	>=dev-python/cheetah-0.9.15[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.3[${PYTHON_USEDEP}]
	virtual/python-imaging[${PYTHON_USEDEP}]
	>=dev-python/medusa-0.5.4[${PYTHON_USEDEP}]
	>=dev-python/pyrex-0.5[${PYTHON_USEDEP}]
	>=dev-python/soappy-0.11.1[${PYTHON_USEDEP}]
	virtual/jpeg
	sys-libs/zlib"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS=( OVERVIEW )
PATCHES=(
	"${FILESDIR}/${PN}-0.6.5-py2.3.patch"
	"${FILESDIR}/${PN}-pillow.patch"
)
