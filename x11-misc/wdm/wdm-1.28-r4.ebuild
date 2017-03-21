# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit pam

DESCRIPTION="WINGs Display Manager"
HOMEPAGE="https://github.com/voins/wdm"
SRC_URI="http://voins.program.ru/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc x86"
IUSE="pam selinux truetype"

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

PATCHES=(
	"${FILESDIR}"/${P}-terminateServer.patch
	"${FILESDIR}"/${P}-remove-fakehome.patch
)

src_configure() {
	econf \
		--with-wdmdir="${EPREFIX}"/etc/X11/wdm \
		$(use_enable pam) \
		$(use_enable selinux)
}

src_install() {
	default

	rm -f "${ED%/}"/etc/pam.d/wdm || die
	pamd_mimic system-local-login wdm auth account password session
}
