# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Debian Etch instance example for Ganeti"
HOMEPAGE="http://code.google.com/p/ganeti/"
SRC_URI="http://ganeti.googlecode.com/files/${P}.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="
	app-arch/dpkg
	app-arch/dump
	app-emulation/ganeti
	dev-util/debootstrap
	>=sys-apps/coreutils-6.10-r1
	sys-apps/util-linux
	sys-fs/e2fsprogs
"

src_install() {
	dir=/srv/ganeti/os/debian-etch/
	insinto ${dir}
	doins "${S}"/*
	fperms 755 ${dir}/{create,export,import,rename}
}
