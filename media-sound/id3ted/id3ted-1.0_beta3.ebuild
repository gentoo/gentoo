# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/id3ted/id3ted-1.0_beta3.ebuild,v 1.3 2012/08/27 14:33:39 johu Exp $

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
