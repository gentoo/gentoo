# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Linux quota tools"
HOMEPAGE="https://sourceforge.net/projects/linuxquota/"
SRC_URI="https://downloads.sourceforge.net/linuxquota/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ~ppc ppc64 ~riscv ~sparc x86"
IUSE="ldap netlink nls rpc selinux tcpd"

RDEPEND="
	sys-fs/e2fsprogs
	ldap? ( >=net-nds/openldap-2.3.35:= )
	netlink? (
		sys-apps/dbus
		dev-libs/libnl:3
	)
	rpc? (
		elibc_glibc? ( sys-libs/glibc[-rpc(-)] )
		net-libs/libtirpc:=
		net-libs/rpcsvc-proto
	)
	tcpd? ( sys-apps/tcp-wrappers )
"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"
PDEPEND="rpc? ( net-nds/rpcbind )"
RDEPEND+=" selinux? ( sec-policy/selinux-quota )"

src_configure() {
	local myeconfargs=(
		--enable-ext2direct
		$(use_enable nls)
		$(use_enable ldap ldapmail)
		$(use_enable netlink)
		$(use_enable rpc)
		$(use_enable rpc rpcsetquota)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc doc/* README.* Changelog

	insinto /etc
	insopts -m0644
	doins warnquota.conf quotatab

	newinitd "${FILESDIR}"/quota.rc7 quota
	newconfd "${FILESDIR}"/quota.confd quota

	if use rpc ; then
		newinitd "${FILESDIR}"/rpc.rquotad.initd rpc.rquotad
	fi

	if use ldap ; then
		insinto /etc/openldap/schema
		insopts -m0644
		doins "${FILESDIR}"/ldap-scripts/quota.schema

		exeinto /usr/share/quota/ldap-scripts
		doexe "${FILESDIR}"/ldap-scripts/*.pl
		doexe "${FILESDIR}"/ldap-scripts/edquota_editor
	fi
}
