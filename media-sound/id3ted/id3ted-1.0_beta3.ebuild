# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs

MY_P=${PN}-${PV/_beta/b}
DESCRIPTION="A Command-line ID3 Tag Editor"
HOMEPAGE="http://muennich.github.com/id3ted/"
SRC_URI="mirror://github/muennich/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-libs/taglib
	sys-apps/file"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	export PREFIX="/usr"
	tc-export CXX
}
