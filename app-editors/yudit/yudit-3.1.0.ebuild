# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Free (Y)unicode text editor for all unices"
HOMEPAGE="https://www.yudit.org/"
SRC_URI="https://yudit.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext"

src_prepare() {
	default
	# Don't strip binaries, let portage do that.
	sed -i "/^INSTALL_PROGRAM/s: -s::" Makefile.conf.in || die "sed failed"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc {BUGS,CHANGELOG,NEWS,TODO}.TXT
}
