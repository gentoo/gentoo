# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils toolchain-funcs

DEB_VER="7"
DESCRIPTION="ACE unarchiver"
HOMEPAGE="http://www.winace.com/"
SRC_URI="mirror://debian/pool/non-free/u/unace-nonfree/unace-nonfree_${PV}.orig.tar.gz
	mirror://debian/pool/non-free/u/unace-nonfree/unace-nonfree_${PV}-${DEB_VER}.debian.tar.gz"

LICENSE="freedist"
SLOT="1"
KEYWORDS="alpha amd64 arm hppa ppc ppc64 s390 x86 ~amd64-linux ~x86-linux ~sparc-solaris"
IUSE=""

src_prepare() {
	epatch $(sed 's:^:../debian/patches/:' "${WORKDIR}"/debian/patches/series)
}

src_configure() {
	tc-export CC
}

src_install() {
	dobin unace
	doman "${WORKDIR}"/debian/manpage/unace.1
}
