# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyndex/pyndex-0.3.2a.ebuild,v 1.12 2014/08/10 21:17:01 slyfox Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils

MY_PN="Pyndex"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Simple and fast Python full-text indexer (aka search engine) using Metakit as its back-end"
HOMEPAGE="http://www.divmod.org/Pyndex/index.html"
SRC_URI="mirror://sourceforge/pyndex/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=">=dev-db/metakit-2.4.9.2[python]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
