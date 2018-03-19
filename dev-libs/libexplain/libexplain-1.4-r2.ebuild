# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Library which may be used to explain Unix and Linux system call errors"
HOMEPAGE="http://libexplain.sourceforge.net/"
SRC_URI="http://libexplain.sourceforge.net/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-3 LGPL-3"
IUSE="static-libs"

DEPEND="
	sys-apps/acl
	sys-apps/groff
	app-text/ghostscript-gpl
	>=sys-kernel/linux-headers-2.6.35"

RDEPEND="
	${DEPEND}
	sys-libs/libcap
	sys-process/lsof
	sys-libs/glibc"

# Test fails with:
# This is not a bug, but it does indicate where libexplain's ioctl support
# could be improved.
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-0.45-configure.patch
	"${FILESDIR}"/libexplain-missing-defines.patch
)

src_prepare() {
	# Portage incompatible test
	sed \
		-e '/t0524a/d' \
		-e '/t0363a/d' \
		-i Makefile.in || die

	cp -v "${S}"/etc/configure.ac "${S}" || die
	default
	eautoreconf
}

src_install() {
	default
}
