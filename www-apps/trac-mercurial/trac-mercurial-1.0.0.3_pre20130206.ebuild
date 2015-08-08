# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils mercurial

MY_PN="TracMercurial"
MY_P="${MY_PN}-${PV/_pre/dev-r}"

DESCRIPTION="A Mercurial plugin for Trac"
HOMEPAGE="http://trac.edgewall.org/"
EHG_REPO_URI="https://hg.edgewall.org/trac/mercurial-plugin"
EHG_REVISION="8df754d9b36a"

LICENSE="GPL-2"
SLOT="0"
# KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND=">=www-apps/trac-1.0
		>=dev-vcs/mercurial-1.1"

S="${WORKDIR}/${MY_P}"
