# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="NVM-Express user space tooling for Linux"
HOMEPAGE="https://github.com/linux-nvme/nvme-cli"
SRC_URI="https://github.com/linux-nvme/nvme-cli/archive/v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="sys-libs/libcap"
DEPEND="${RDEPEND}"

src_prepare() {
	sed 's|-m64 \(-std=gnu99\) -O2 -g \(-pthread -D_GNU_SOURCE -D_REENTRANT -Wall\) -Werror|\1 \2|' \
		-i Makefile || die
	sed 's|/usr/local|$(DESTDIR)/$(PREFIX)/share|' \
		-i Documentation/Makefile || die

	default
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
}
