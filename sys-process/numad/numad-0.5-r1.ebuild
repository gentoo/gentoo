# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/numad/numad-0.5-r1.ebuild,v 1.3 2014/05/24 10:10:20 ago Exp $

EAPI=5

inherit linux-info toolchain-funcs

if [[ ${PV} = *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://git.fedorahosted.org/numad.git"
	KEYWORDS="~amd64 -arm -s390 x86"
else
	SRC_URI="http://git.fedorahosted.org/git/?p=numad.git;a=snapshot;h=334278ff3d774d105939743436d7378a189e8693;sf=tbz2 -> numad-0.5-334278f.tar.bz2"
	KEYWORDS="amd64 -arm -s390 x86"
	S="${WORKDIR}/${PN}-334278f"
fi

DESCRIPTION="The NUMA daemon that manages application locality"
HOMEPAGE="http://fedoraproject.org/wiki/Features/numad"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

CONFIG_CHECK="~NUMA ~CPUSETS"

src_prepare() {
	EPATCH_FORCE=yes EPATCH_SUFFIX="patch" EPATCH_SOURCE="${FILESDIR}" \
		epatch

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
