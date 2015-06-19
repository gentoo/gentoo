# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/uchime/uchime-4.2.40.ebuild,v 1.1 2012/08/14 15:36:10 jlec Exp $

EAPI=4

inherit cmake-utils

MY_P="${PN}${PV}_src"

DESCRIPTION="Fast, accurate chimera detection"
HOMEPAGE="http://www.drive5.com/uchime/"
SRC_URI="http://drive5.com/${PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	cp "${FILESDIR}"/CMakeLists.txt . || die
}
