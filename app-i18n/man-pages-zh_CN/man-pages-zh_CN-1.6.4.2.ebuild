# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A somewhat comprehensive collection of Chinese Linux man pages"
HOMEPAGE="https://github.com/man-pages-zh/manpages-zh"
MY_PN="manpages-zh"
MY_P="${MY_PN}-${PV}"
SRC_URI="https://github.com/man-pages-zh/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="FDL-1.2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="virtual/man"

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	local prune_manpages=(
		# groups' zh_CN manpage is already provided by sys-apps/shadow
		# to avoid file collision, we have to remove it
		groups.1

		# Avoid collisions with >=sys-process/procps-4.0.5
		pgrep.1 pidof.1 free.1 pmap.1 ps.1 pwdx.1 slabtop.1
		tload.1 sysctl.8 vmstat.8 uptime.1 w.1 watch.1 top.1
		procps.3 procps_misc.3 procps_pids.3 sysctl.conf.5
	)
	local man
	for man in "${prune_manpages[@]}" ; do
		rm -fv src/man${man#*.}/${man} || die
	done

	doman -i18n=zh_CN src/man?/*.[1-9]*
	dodoc README.md AUTHORS ChangeLog NEWS
}
