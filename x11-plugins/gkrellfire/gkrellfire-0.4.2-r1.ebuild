# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="CPU load flames for GKrellM 2"
HOMEPAGE="http://people.freenet.de/thomas-steinke"
SRC_URI="ftp://ftp.freebsd.org/pub/FreeBSD/ports/distfiles/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-admin/gkrellm[X]"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/fix-CC-CFLAGS-LDFLAGS-handling.patch" )

src_compile() {
	emake CC="$(tc-getCC)"
}
