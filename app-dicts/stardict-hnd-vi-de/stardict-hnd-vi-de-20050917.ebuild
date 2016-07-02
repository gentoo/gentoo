# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

FROM_LANG="Vietnamese"
TO_LANG="German"

inherit stardict

HOMEPAGE="https://sourceforge.net/projects/ovdp/"
SRC_URI="mirror://gentoo/VietDuc12K.zip"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}/VietDuc
