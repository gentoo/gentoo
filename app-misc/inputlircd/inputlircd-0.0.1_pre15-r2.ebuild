# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit toolchain-funcs eutils versionator

DESCRIPTION="Inputlirc daemon to utilize /dev/input/event*"
HOMEPAGE="http://svn.sliepen.eu.org/inputlirc/trunk"
SRC_URI="http://gentooexperimental.org/~genstef/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~x86"

src_prepare() {
	local ver="$(best_version sys-kernel/linux-headers)"
	ver=${ver#sys-kernel/linux-headers-}
	if version_is_at_least 4.4 ${ver} ; then
		epatch "${FILESDIR}/inputlircd-linux-4.4-fix.patch"
	fi

	sed -e 's:$(CFLAGS):$(CFLAGS) $(LDFLAGS):' -i Makefile || die

	default
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install

	newinitd "${FILESDIR}"/inputlircd.init.2  inputlircd
	newconfd "${FILESDIR}"/inputlircd.conf  inputlircd
}
