# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils versionator

MY_COMP=( $(get_all_version_components) )
MY_P="${PN}-${MY_COMP[0]}.r${MY_COMP[2]}"

DESCRIPTION="A utility for tracking down wasted disk space"
HOMEPAGE="http://www.chiark.greenend.org.uk/~sgtatham/agedu/"
SRC_URI="http://www.chiark.greenend.org.uk/~sgtatham/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc ipv6"

DEPEND="doc? ( app-doc/halibut )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-r9671-fix-automagic.patch"
	eautoreconf
}

src_configure() {
	econf --enable-ipv4 \
		$(use_enable doc halibut) \
		$(use_enable ipv6)
}
