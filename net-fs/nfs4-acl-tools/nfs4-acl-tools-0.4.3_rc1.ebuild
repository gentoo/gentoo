# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Commandline and GUI tools that deal directly with NFSv4 ACLs"
HOMEPAGE="https://git.linux-nfs.org/?p=steved/nfs4-acl-tools.git;a=summary"
if [[ ${PV} != *_rc* ]] ; then
	SRC_URI="
		https://linux-nfs.org/~steved/${PN}/${P}.tar.gz
	"
	# KEYWORDS="~amd64 ~x86"
else
	SRC_URI="
		https://git.linux-nfs.org/?p=steved/nfs4-acl-tools.git;a=snapshot;h=refs/tags/${P/_/-};sf=tgz
			-> ${P}.tar.gz
	"
	S="${WORKDIR}/${PN}-${P/_/-}"
fi

LICENSE="GPL-2"
SLOT="0"

# TODO only for 0.4.3_rc1
# - it has minimal changes compared to 0.4.2
# - no new release since 2022-11-22
# - so we might as well keyword this as well
KEYWORDS="~amd64 ~x86"

RESTRICT="test"

RDEPEND="sys-apps/attr"
DEPEND="
	${RDEPEND}
	elibc_musl? ( sys-libs/queue-standalone )
"

PATCHES=(
	"${FILESDIR}/${PN}-0.3.7-libtool.patch" # bug #731162
	"${FILESDIR}/${PN}-0.3.5-jobserver-unavailable.patch"
	"${FILESDIR}/${PN}-0.4.2-libattr.patch"
)

src_prepare() {
	default
	eautoreconf
}
