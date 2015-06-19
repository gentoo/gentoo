# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libnipper/libnipper-0.12.6-r1.ebuild,v 1.4 2014/03/29 21:54:56 ikelos Exp $

EAPI=4

inherit base cmake-utils

DESCRIPTION="A router configuration security analysis library"
HOMEPAGE="http://nipper.titania.co.uk/"
SRC_URI="mirror://sourceforge/nipper/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

PATCHES=(
	"${FILESDIR}/${P}-glibc-2.10.patch"
	"${FILESDIR}/${P}-gcc47.patch"
	"${FILESDIR}/${P}-multilib-strict.patch"
)
