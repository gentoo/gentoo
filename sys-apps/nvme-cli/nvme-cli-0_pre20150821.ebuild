# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="NVM-Express user space tooling for Linux"
HOMEPAGE="https://github.com/linux-nvme/nvme-cli"
EGIT_COMMIT="709571d77bf618921fd719253da677742c673d06"
SRC_URI="https://github.com/linux-nvme/nvme-cli/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="sys-libs/libcap"
DEPEND="${RDEPEND}"
S=${WORKDIR}/${PN}-${EGIT_COMMIT}

src_prepare() {
	sed 's|-m64 \(-std=gnu99\) -O2 -g \(-pthread -D_GNU_SOURCE -D_REENTRANT -Wall\) -Werror|\1 \2|' \
		-i Makefile || die
	sed 's|/usr/local|$(DESTDIR)/$(PREFIX)/share|' \
		-i Documentation/Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
}
