# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/numad/numad-9999.ebuild,v 1.4 2014/04/23 19:49:02 vapier Exp $

EAPI=5

inherit linux-info toolchain-funcs eutils

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://git.fedorahosted.org/numad.git"
	inherit git-2
else
	SRC_URI=""
	KEYWORDS="~amd64 ~x86 -arm -s390"
fi

DESCRIPTION="The NUMA daemon that manages application locality"
HOMEPAGE="http://fedoraproject.org/wiki/Features/numad"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

CONFIG_CHECK="~NUMA ~CPUSETS"

src_prepare() {
	epatch "${FILESDIR}"/0001-Fix-man-page-directory-creation.patch
	tc-export CC
}

src_configure() {
	:
}

src_compile() {
	emake CFLAGS="${CFLAGS} -std=gnu99"
}

src_install() {
	emake prefix="${ED}/usr" install
}
