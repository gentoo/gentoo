# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils

DESCRIPTION="Linux quota tools"
HOMEPAGE="http://sourceforge.net/projects/linuxquota/"
SRC_URI="mirror://sourceforge/linuxquota/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="ldap netlink nls rpc tcpd"

RDEPEND="ldap? ( >=net-nds/openldap-2.3.35 )
	netlink? (
		sys-apps/dbus
		dev-libs/libnl:1.1
	)
	rpc? ( net-nds/rpcbind )
	tcpd? ( sys-apps/tcp-wrappers )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/quota-tools

src_prepare() {
	local args=(
		-e '1iCC = @CC@' #446277
	)
	if ! use rpc ; then
		args+=( #465810
			-e '/^PROGS/s:rpc.rquotad::'
			-e '/^RPCGEN/s:=.*:=false:'
			-e '/^RPCCLNTOBJS/s:=.*:=:'
		)
	fi
	sed -i "${args[@]}" Makefile.in || die
	epatch "${FILESDIR}"/${PN}-4.01-mnt.patch \
		"${FILESDIR}"/${PN}-4.01-cflags.patch
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable ldap ldapmail) \
		$(use_enable netlink) \
		$(use_enable rpc) \
		$(use_enable rpc rpcsetquota)
}

src_install() {
	emake STRIP="" ROOTDIR="${D}" install
	dodoc doc/* README.* Changelog
	rm -r "${ED}"/usr/include || die #70938

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
		doins ldap-scripts/quota.schema

		exeinto /usr/share/quota/ldap-scripts
		doexe ldap-scripts/*.pl
		doexe ldap-scripts/edquota_editor
	fi
}
