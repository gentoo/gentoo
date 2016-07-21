# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
