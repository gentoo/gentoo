# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=yes
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils

DESCRIPTION="Library which may be used to explain Unix and Linux system call errors"
HOMEPAGE="http://libexplain.sourceforge.net/"
SRC_URI="http://libexplain.sourceforge.net/${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-3 LGPL-3"
IUSE="doc static-libs"

RDEPEND="
	sys-libs/libcap
	>=sys-libs/glibc-2.11
	sys-process/lsof"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.35
	app-text/ghostscript-gpl
	sys-apps/groff
"

DOCS=( README )

PATCHES=(
	"${FILESDIR}"/${PN}-0.45-configure.patch
)

src_prepare() {
	# Portage incompatible test
	sed \
		-e '/t0524a/d' \
		-e '/t0363a/d' \
		-i Makefile.in || die

	cp "${S}"/etc/configure.ac "${S}" || die

	autotools-utils_src_prepare
}

src_compile() {
	autotools-utils_src_compile
	use doc && autotools-utils_src_compile all-doc
}
