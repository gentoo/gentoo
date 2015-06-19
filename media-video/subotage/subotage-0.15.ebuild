# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/subotage/subotage-0.15.ebuild,v 1.1 2013/05/12 07:08:13 mgorny Exp $

EAPI=5

DESCRIPTION="Universal subtitle converter in bash"
HOMEPAGE="http://sourceforge.net/projects/subotage/"
SRC_URI="mirror://sourceforge/${PN}/${P/-/_}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}

src_install() {
	default # for docs

	dobin subotage.sh
}
