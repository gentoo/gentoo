# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

FROM_LANG="French"
TO_LANG="Vietnamese"

inherit stardict

HOMEPAGE="https://sourceforge.net/projects/ovdp/"
SRC_URI="mirror://gentoo/PhapViet47K.zip"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}/PhapViet
