# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Linux quota tools"
HOMEPAGE="https://sourceforge.net/projects/linuxquota/"
SRC_URI="mirror://sourceforge/linuxquota/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="ldap netlink nls rpc tcpd"

RDEPEND="
	ldap? ( >=net-nds/openldap-2.3.35 )
	netlink? (
		sys-apps/dbus
		dev-libs/libnl:3
	)
	rpc? (
		net-nds/rpcbind
		|| (	sys-libs/glibc[rpc(-)]
			(
				net-libs/rpcsvc-proto
			)
		)
	)
	tcpd? ( sys-apps/tcp-wrappers )
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--docdir="${EPREFIX%/}/usr/share/doc/${PF}"
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
