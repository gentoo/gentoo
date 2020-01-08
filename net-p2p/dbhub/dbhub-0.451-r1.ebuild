# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Hub software for Direct Connect, fork of opendchub"
HOMEPAGE="http://www.dbhub.org"
SRC_URI="mirror://sourceforge/${PN}/${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug perl nls switch-user"

DEPEND="perl? ( dev-lang/perl )
	switch-user? ( sys-libs/libcap )"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-gentoo.patch"
	"${FILESDIR}/${PN}-no-dynaloader.patch"
	"${FILESDIR}/${PN}-fix-buffer-overflows.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable perl) \
		$(use_enable switch-user switch_user) \
		$(use_enable debug)
}
