# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit linux-mod

DESCRIPTION="PCIE RTS5209 card reader driver for Linux"
HOMEPAGE="http://www.realtek.com.tw/Downloads/downloadsView.aspx?PNid=15&PFid=25&Level=4&Conn=3&DownTypeID=3"
SRC_URI="https://dev.gentoo.org/~vikraman/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

MODULE_NAMES="rts_pstor(misc/drivers/scsi)"
BUILD_TARGETS="default"

src_prepare() {
	sed -e 's/\/lib\/modules\/\$(shell uname -r)\/build\//\$(KERNELDIR)/g' \
		-i Makefile || die "Sed failed!"
	([ ${KV_MAJOR} -gt 3 ] || ([ ${KV_MAJOR} -eq 3 ] && [ ${KV_MINOR} -ge 8 ])) \
		&& epatch "${FILESDIR}/${PN}-linux-3.8.patch"
	([ ${KV_MAJOR} -gt 3 ] || ([ ${KV_MAJOR} -eq 3 ] && [ ${KV_MINOR} -ge 10 ])) \
		&& epatch "${FILESDIR}/${PN}-linux-3.10.patch"
	epatch "${FILESDIR}/${PN}-vmalloc.patch"
}

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KERNELDIR=${KERNEL_DIR}"
}
