# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"
inherit python

DESCRIPTION="release metatool used for creating Gentoo and Funtoo releases"
HOMEPAGE="https://www.github.com/funtoo/metro"
SRC_URI="http://www.funtoo.org/archive/metro/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+ccache +git threads"

DEPEND=""
RDEPEND="threads? ( app-arch/pbzip2 )
	ccache? ( dev-util/ccache )
	git? ( dev-vcs/git )"

src_install() {
	insinto /usr/lib/metro
	doins -r .
	fperms 0755 /usr/lib/metro/metro
	dosym /usr/lib/metro/metro /usr/bin/metro
	python_convert_shebangs -r 2 "${ED}"
}
