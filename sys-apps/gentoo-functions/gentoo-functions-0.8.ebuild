# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gentoo-functions/gentoo-functions-0.8.ebuild,v 1.4 2015/02/28 13:25:17 grobian Exp $

EAPI=5

if [[ ${PV} = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/gentoo/${PN}.git"
else
	SRC_URI="http://dev.gentoo.org/~williamh/dist/${P}.tar.bz2
	prefix? ( http://dev.gentoo.org/~grobian/distfiles/consoletype-1.0.sh )"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
fi

inherit toolchain-funcs

DESCRIPTION="base functions required by all gentoo systems"
HOMEPAGE="http://www.gentoo.org"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

src_prepare() {
	tc-export CC

	# in prefix, use shell script, for the C-code doesn't compile
	use prefix && cp "${DISTDIR}"/consoletype-1.0.sh consoletype
}

src_install() {
	emake install DESTDIR="${ED}"
}
