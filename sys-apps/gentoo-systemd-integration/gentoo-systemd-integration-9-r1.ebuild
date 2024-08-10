# Copyright 2013-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd udev

DESCRIPTION="systemd integration files for Gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Systemd"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/gentoo-systemd-integration.git"
	inherit autotools git-r3
else
	SRC_URI="https://dev.gentoo.org/~floppym/dist/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="acct-group/floppy
	acct-group/usb
	>=sys-apps/systemd-207
	!sys-fs/eudev
	!sys-fs/udev"
DEPEND=">=sys-apps/systemd-207"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	[[ ${PV} != 9999 ]] || eautoreconf
}

src_configure() {
	local myconf=(
		--with-systemdsystemgeneratordir="$(systemd_get_systemgeneratordir)"
		--with-systemdsystempresetdir="$(systemd_get_systempresetdir)"
		udevdir="${EPREFIX}$(get_udevdir)"
	)
	econf "${myconf[@]}"
}
