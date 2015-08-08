# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit linux-info

if [[ ${PV} = *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://git.fedorahosted.org/numad.git"
	KEYWORDS="-arm -s390"
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

DEPEND=""
RDEPEND="${DEPEND}"

CONFIG_CHECK="~NUMA ~CPUSETS"

src_prepare() {
	EPATCH_FORCE=yes EPATCH_SUFFIX="patch" EPATCH_SOURCE="${FILESDIR}" \
		epatch
}

src_configure() {
	:
}

src_install() {
	emake prefix="${ED}/usr" install
}
