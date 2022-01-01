# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/gentoo-systemd-integration.git"
	inherit autotools git-r3
else
	SRC_URI="https://dev.gentoo.org/~floppym/dist/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DESCRIPTION="systemd integration files for Gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Systemd"

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=">=sys-apps/systemd-207
	!sys-fs/eudev
	!sys-fs/udev"
DEPEND=">=sys-apps/systemd-207"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	[[ ${PV} != 9999 ]] || eautoreconf
}
