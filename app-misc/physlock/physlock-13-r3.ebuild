# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs pam

DESCRIPTION="Lightweight Linux console locking tool"
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

PATCHES=(
	"${FILESDIR}/${PN}-13-Set-PAM_TTY.patch"
	"${FILESDIR}/${PN}-13-Improved-commandline-help.patch"
)

pkg_setup() {
	export MY_CONF="HAVE_SYSTEMD=$(usex systemd 1 0) HAVE_ELOGIND=$(usex elogind 1 0)"
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
	newpamd physlock.pam ${PN}
}
