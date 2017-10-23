# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3

DESCRIPTION="Compiz Option code Generator"
HOMEPAGE="https://github.com/compiz-reloaded"
EGIT_REPO_URI="https://github.com/compiz-reloaded/compiz-bcop.git"

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="dev-libs/libxslt"

DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare(){
	default
	eautoreconf
}
