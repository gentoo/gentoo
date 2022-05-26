# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools pam toolchain-funcs

DESCRIPTION="WINGs Display Manager"
HOMEPAGE="https://github.com/voins/wdm"
SRC_URI="http://voins.program.ru/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~ppc64 ~sparc x86"
IUSE="pam selinux truetype"

DEPEND="
	virtual/libcrypt:=
	>=x11-wm/windowmaker-0.70.0
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
	pam? ( sys-libs/pam )
	truetype? ( x11-libs/libXft )
"
RDEPEND="${DEPEND}
	pam? ( >=sys-auth/pambase-20080219.1 )
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-terminateServer.patch
	"${FILESDIR}"/${P}-remove-fakehome.patch
	"${FILESDIR}"/${P}-pkg_config.patch
	"${FILESDIR}"/${P}-ar.patch
)

src_prepare() {
	default
	eautoreconf
}
src_configure() {
	tc-export AR
	econf \
		--with-wdmdir="${EPREFIX}"/etc/X11/wdm \
		$(use_enable pam) \
		$(use_enable selinux)
}

src_install() {
	default

	rm -f "${ED}"/etc/pam.d/wdm || die

	if use pam; then
		pamd_mimic system-local-login wdm auth account password session
	fi
}
