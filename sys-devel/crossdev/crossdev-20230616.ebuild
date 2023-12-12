# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

if [[ ${PV} == "99999999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="
		https://anongit.gentoo.org/git/proj/crossdev.git
		https://github.com/gentoo/crossdev
	"
else
	SRC_URI="https://dev.gentoo.org/~floppym/dist/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
fi

DESCRIPTION="Gentoo Cross-toolchain generator"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Crossdev"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	>=sys-apps/portage-2.1
	app-shells/bash
	sys-apps/gentoo-functions
	sys-apps/config-site
"
BDEPEND="app-arch/xz-utils"

src_install() {
	default

	if [[ ${PV} == "99999999" ]] ; then
		sed -i "s:@CDEVPV@:${EGIT_VERSION}:" "${ED}"/usr/bin/crossdev || die
	fi

	dodir /usr/share/config.site.d
	mv "${ED}"/usr/share/config.site{,.d/80crossdev.conf} || die
}
