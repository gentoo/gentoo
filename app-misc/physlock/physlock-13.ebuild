# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="lightweight Linux console locking tool"
HOMEPAGE="https://github.com/muennich/physlock"
SRC_URI="https://github.com/muennich/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

IUSE="elogind systemd"
REQUIRED_USE="?? ( elogind systemd )"

RDEPEND="sys-libs/pam"
DEPEND="${RDEPEND}
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd )
"

pkg_setup() {
	export MY_CONF="HAVE_SYSTEMD=$(usev systemd) HAVE_ELOGIND=$(usev elogind)"
}

src_prepare() {
	default
	tc-export CC
}

src_compile() {
	emake ${MY_CONF}
}

src_install() {
	emake ${MY_CONF} DESTDIR="${D}" PREFIX=/usr install
	dosym login /etc/pam.d/${PN}
}
