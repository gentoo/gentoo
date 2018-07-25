# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="Tktable${PV}"

DESCRIPTION="full-featured 2D table widget"
HOMEPAGE="http://tktable.sourceforge.net/"
SRC_URI="mirror://sourceforge/tktable/${MY_P}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 ppc x86"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/tk-8.0"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

HTML_DOCS=( doc/tkTable.html )
DOCS=( ChangeLog README.txt release.txt )

src_prepare() {
	default
	sed -e '/^install:/{s: install-doc::}' \
		-e '/^PKG_EXTRA_FILES/{s:=.*:=:}' -i Makefile.in || die
}
