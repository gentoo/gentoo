# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Userspace tools for managing VDO volumes"
HOMEPAGE="https://github.com/dm-vdo/vdo"
SRC_URI="https://github.com/dm-vdo/vdo/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

# libdevmapper.h & more
DEPEND="
	sys-fs/lvm2
	sys-apps/util-linux
"
RDEPEND="
	${DEPEND}
	virtual/libudev:=
"
BDEPEND="
	virtual/pkgconfig
"

src_install() {
	emake install \
		DESTDIR="${D}" \
		bindir=/usr/bin \
		mandir=/usr/share/man
	mv "${D}"/usr/share/doc/{vdo,"${P}"}
}
