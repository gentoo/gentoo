# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit elisp

DESCRIPTION="Emacs Major Mode for SGML and XML DTDs"
HOMEPAGE="http://www.menteith.com/wiki/tdtd"
SRC_URI="http://www.menteith.com/raw-attachment/wiki/tdtd/data/${PN}${PV//./}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"
SITEFILE=50${PN}-gentoo.el
DOCS="TODO changelog.txt readme.txt tutorial.txt"
