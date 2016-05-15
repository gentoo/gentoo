# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Transition package moving to single ${CATEGORY}/oracle-instantclient package"
HOMEPAGE="https://bugs.gentoo.org/show_bug.cgi?id=524922#c12"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND=">=dev-db/oracle-instantclient-12[sdk]"
