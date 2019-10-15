# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

MY_P="${PN}-1.50"
DESCRIPTION="A major mode for editing comma-separated value files"
HOMEPAGE="http://centaur.maths.qmw.ac.uk/Emacs/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

S="${WORKDIR}/${MY_P}"
SITEFILE="50${PN}-gentoo.el"
