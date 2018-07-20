# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils systemd

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://linux-nfs.org/~steved/rpcbind.git"
	inherit autotools git-r3
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

DESCRIPTION="portmap replacement which supports RPC over various protocols"
HOMEPAGE="https://sourceforge.net/projects/rpcbind/"

LICENSE="BSD"
SLOT="0"
IUSE="debug selinux systemd tcpd warmstarts"
REQUIRED_USE="systemd? ( warmstarts )"

CDEPEND=">=net-libs/libtirpc-0.2.3:=
	systemd? ( sys-apps/systemd:= )
	tcpd? ( sys-apps/tcp-wrappers )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-rpcbind )"

src_prepare() {
	[[ ${PV} == "9999" ]] && eautoreconf
	epatch_user
}

src_configure() {
	econf \
		--with-statedir="${EPREFIX}"/run/${PN} \
		--with-systemdsystemunitdir=$(usex systemd "$(systemd_get_unitdir)" "no") \
		$(use_enable tcpd libwrap) \
		$(use_enable debug) \
		$(use_enable warmstarts)
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
