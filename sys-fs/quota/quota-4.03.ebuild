# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

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
		dev-libs/libnl:3
	)
	rpc? ( net-nds/rpcbind )
	tcpd? ( sys-apps/tcp-wrappers )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

PATCHES=(
	# Patches from upstream
	"${FILESDIR}/${P}-fix_build_without_ldap.patch"
	"${FILESDIR}/${P}-distribute_ldap-scripts.patch"
	"${FILESDIR}/${P}-explicitely_print_disabled_options.patch"
	"${FILESDIR}/${P}-respect_docdir.patch"
	"${FILESDIR}/${P}-dont_override_cflags.patch"
	"${FILESDIR}/${P}-default_fpic_fpie.patch"
	"${FILESDIR}/${P}-repqouta_F_option_arg.patch"
	"${FILESDIR}/${P}-noldap_linking.patch"

	# Patches not (yet) upstreamed
	"${FILESDIR}/${P}-no_rpc.patch"
)

src_prepare() {
	epatch "${PATCHES[@]}"

	eautoreconf
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
	emake DESTDIR="${D}" install
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
