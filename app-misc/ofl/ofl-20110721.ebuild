# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ofl/ofl-20110721.ebuild,v 1.1 2011/08/31 23:48:47 mattst88 Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Open file lister (replaces fuser and lsof -m)"
HOMEPAGE="http://jengelh.medozas.de/projects/hxtools/"
SRC_URI="http://jftp.medozas.de/hxtools/hxtools-${PV}.tar.xz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=sys-libs/libhx-3.4"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/hxtools-${PV}

src_configure() {
	# We're just building a single utility. Don't bother
	# with the build system.
	:
}

src_compile() {
	CC=$(tc-getCC) CFLAGS=${CFLAGS} LDLIBS="-lHX" \
		emake V=1 -C sadmin ofl
}

src_install() {
	dobin sadmin/ofl
	doman doc/ofl.1
}
