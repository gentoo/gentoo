# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit systemd

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://dev.tty0.ch/btrbk.git"
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://digint.ch/download/btrbk/releases/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="Tool for creating snapshots and remote backups of btrfs subvolumes"
HOMEPAGE="https://digint.ch/btrbk/"
LICENSE="GPL-3+"
SLOT="0"
IUSE="+pv"

DEPEND=""
RDEPEND="dev-lang/perl
	net-misc/openssh
	pv? ( sys-apps/pv )
	>=sys-fs/btrfs-progs-3.18.2"

src_install() {
	emake DESTDIR="${D}" DOCDIR="/usr/share/doc/${PF}" SYSTEMDDIR="$(systemd_get_systemunitdir)" install
}
