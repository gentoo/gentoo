# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="Hub software for Direct Connect, fork of opendchub"
HOMEPAGE="https://sourceforge.net/projects/dbhub/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug nls perl switch-user"

DEPEND="
	perl? ( dev-lang/perl )
	switch-user? ( sys-libs/libcap )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-gentoo.patch
	"${FILESDIR}"/${PN}-no-dynaloader.patch
	"${FILESDIR}"/${PN}-fix-buffer-overflows.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-flags -fcommon
	econf \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable perl) \
		$(use_enable switch-user switch_user)
}
