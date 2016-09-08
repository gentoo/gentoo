# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic

DESCRIPTION="Linux quota tools"
HOMEPAGE="https://sourceforge.net/projects/linuxquota/"
SRC_URI="mirror://sourceforge/linuxquota/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="nls tcpd ldap rpc"

RDEPEND="ldap? ( >=net-nds/openldap-2.3.35 )
	tcpd? ( sys-apps/tcp-wrappers )
	rpc? ( || ( net-nds/portmap net-nds/rpcbind ) )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/quota-tools

src_unpack() {
	unpack ${A}
	cd "${S}"

	# patch to prevent quotactl.2 manpage from being installed
	# that page is provided by man-pages instead
	epatch "${FILESDIR}"/${PN}-no-quotactl-manpage.patch

	# This was for openldap-2.2 support before,
	# Now we only support >=2.3
	append-cppflags -DLDAP_DEPRECATED=0

	sed -i -e "s:,LIBS=\"\$saved_LIBS=\":;LIBS=\"\$saved_LIBS\":" configure
}

src_compile() {
	econf \
		$(use_enable nls) \
		$(use_enable ldap ldapmail) \
		$(use_enable rpc) \
		$(use_enable rpc rpcsetquota) \
		|| die
	emake || die
}

src_install() {
	emake STRIP="" ROOTDIR="${D}" install || die
	rm -r "${D}"/usr/include || die #70938

	insinto /etc
	insopts -m0644
	doins warnquota.conf quotatab

	ecvs_clean
	dodoc doc/*
	dodoc README.*
	dodoc Changelog

	newinitd "${FILESDIR}"/quota.rc7 quota
	newconfd "${FILESDIR}"/quota.confd quota

	if use rpc ; then
		newinitd "${FILESDIR}"/rpc.rquotad.initd rpc.rquotad
	else
		rm -f "${D}"/usr/sbin/rpc.rquotad
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
