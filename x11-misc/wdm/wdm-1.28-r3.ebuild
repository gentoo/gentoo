# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils pam

DESCRIPTION="WINGs Display Manager"
HOMEPAGE="http://voins.program.ru/wdm/"
SRC_URI="http://voins.program.ru/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ~ppc64 ~sparc x86"
IUSE="truetype pam selinux"

COMMON_DEPEND=">=x11-wm/windowmaker-0.70.0
	truetype? ( x11-libs/libXft )
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXpm
	pam? ( virtual/pam )"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext"
RDEPEND="${COMMON_DEPEND}
	pam? ( >=sys-auth/pambase-20080219.1 )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-terminateServer.patch
}

src_configure() {
	econf \
		--exec-prefix=/usr \
		--with-wdmdir=/etc/X11/wdm \
		$(use_enable pam) \
		$(use_enable selinux)
}

src_install() {
	emake DESTDIR="${D}" install || die
	rm -f "${D}"/etc/pam.d/wdm
	pamd_mimic system-local-login wdm auth account password session
}
