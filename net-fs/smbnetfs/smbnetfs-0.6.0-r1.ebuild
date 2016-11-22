# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils readme.gentoo

DESCRIPTION="FUSE filesystem for SMB shares"
HOMEPAGE="https://sourceforge.net/projects/smbnetfs"
SRC_URI="mirror://sourceforge/smbnetfs/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm-linux ~x86-linux"
IUSE="gnome"

RDEPEND=">=sys-fs/fuse-2.3:=
	>=net-fs/samba-3.2:=[smbclient(+)]
	>=dev-libs/glib-2.30:=
	gnome? ( gnome-base/libgnome-keyring:= )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/make"

DISABLE_AUTOFORMATTING=yes
DOC_CONTENTS="
For quick usage, exec:
'modprobe fuse'
'smbnetfs -oallow_other /mnt/samba'
"

src_configure() {
	econf $(use_with gnome gnome-keyring)
}

src_install() {
	default
	readme.gentoo_create_doc
	dodoc AUTHORS ChangeLog
}
