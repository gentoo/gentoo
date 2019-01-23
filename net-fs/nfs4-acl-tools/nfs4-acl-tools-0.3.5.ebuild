# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

DESCRIPTION="Commandline and GUI tools that deal directly with NFSv4 ACLs"
HOMEPAGE="https://git.linux-nfs.org/?p=bfields/nfs4-acl-tools.git;a=summary"
SRC_URI="https://linux-nfs.org/~bfields/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-apps/attr"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-0.3.5-jobserver-unavailable.patch )

src_prepare() {
	default

	eautoreconf
}
