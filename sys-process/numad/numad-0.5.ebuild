# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit linux-info

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://pagure.io/numad.git"
	inherit git-r3
else
	HASH="334278ff3d774d105939743436d7378a189e8693"
	SRC_URI="mirror://gentoo/numad-0.5-${HASH:0:7}.tar.bz2"
	KEYWORDS="amd64 -arm -s390 x86"
	S="${WORKDIR}/${PN}-${HASH:0:7}"
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
}

src_install() {
	emake prefix="${ED}/usr" install
}
