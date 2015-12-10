# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Simple wrapper around cryptsetup for encrypted containers"
HOMEPAGE="http://git.zx2c4.com/ctmg/about/"
SRC_URI="http://git.zx2c4.com/${PN}/snapshot/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64"
IUSE=""

DEPEND=""
RDEPEND="sys-fs/cryptsetup sys-apps/util-linux sys-fs/e2fsprogs sys-apps/coreutils app-admin/sudo"

src_compile() { :; }

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
