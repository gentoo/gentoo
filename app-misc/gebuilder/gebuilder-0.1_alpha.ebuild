# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Gentoo System and Image Builder"
HOMEPAGE="https://github.com/IBT-FMI/gebuilder/"
SRC_URI="https://github.com/IBT-FMI/gebuilder/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="autoupdate btrfs docker"

DEPEND="
	>=app-shells/bash-4.2:4.2
	dev-python/python-glanceclient
	net-misc/rsync
	sys-apps/portage
	sys-apps/util-linux
	sys-boot/syslinux
	sys-fs/duperemove
	sys-kernel/dracut
"
RDEPEND="${DEPEND}
	autoupdate? ( virtual/cron )
	btrfs? ( sys-fs/btrfs-progs )
	docker? ( app-emulation/docker )
"

src_install() {
	cd gebuilder
	insinto /usr/share/gebuilder
	doins -r utils config
	exeinto /usr/bin
	doexe gebuild
	insopts "-m0755"
	doins -r exec.sh scripts

	if use autoupdate; then
		einfo "Installing weekly cron job:"
		insinto /etc/cron.weekly
		doins "${FILESDIR}/gebuilder_global_update"
	fi
}
