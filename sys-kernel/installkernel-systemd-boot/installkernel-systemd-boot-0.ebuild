# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Wrap kernel-install from systemd-boot as installkernel"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI=""
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="|| ( sys-apps/systemd sys-boot/systemd-boot )
	!<sys-apps/debianutils-4.9-r1[installkernel(+)]
	!sys-kernel/installkernel-gentoo"

src_install() {
	# we could technically use a symlink here but it would require
	# us to know the correct path, and that implies /usr merge problems
	into /
	newsbin - installkernel <<-EOF
		#!/bin/sh
		exec kernel-install add "\${1}" "\${2}"
	EOF
}
