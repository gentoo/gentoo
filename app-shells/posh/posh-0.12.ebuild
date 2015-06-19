# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/posh/posh-0.12.ebuild,v 1.1 2013/05/13 07:36:38 mgorny Exp $

EAPI=5
inherit autotools-utils

DESCRIPTION="Reimplementation of Bourne shell based on pdksh"
HOMEPAGE="http://packages.debian.org/posh"
SRC_URI="mirror://debian/pool/main/p/posh/${P/-/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RESTRICT=test

#PATCHES=(
#	"${FILESDIR}"/${PN}-glibc-2.16.patch
#)

src_configure() {
	myeconfargs=(
		--exec-prefix=/
	)
	autotools-utils_src_configure
}
