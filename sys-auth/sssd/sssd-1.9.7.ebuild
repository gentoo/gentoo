# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/sssd/sssd-1.9.7.ebuild,v 1.2 2015/04/10 00:23:33 blueness Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_PRUNE_LIBTOOL_FILES=all

inherit python-single-r1 multilib pam linux-info autotools-utils systemd

DESCRIPTION="System Security Services Daemon provides access to identity and authentication"
HOMEPAGE="http://fedorahosted.org/sssd/"
SRC_URI="http://fedorahosted.org/released/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="autofs doc +locator netlink nls +manpages python selinux sudo ssh test"

COMMON_DEP="
	virtual/pam
	>=dev-libs/popt-1.16
	dev-libs/glib:2
	>=dev-libs/ding-libs-0.2
	>=sys-libs/talloc-2.0.7
	>=sys-libs/tdb-1.2.9
	>=sys-libs/tevent-0.9.16
	>=sys-libs/ldb-1.1.17-r1:=
	>=net-nds/openldap-2.4.30[sasl]
	>=dev-libs/libpcre-8.30
	>=app-crypt/mit-krb5-1.10.3
	>=sys-apps/keyutils-1.5
	>=net-dns/c-ares-1.7.4
	>=dev-libs/nss-3.12.9
	selinux? (
		>=sys-libs/libselinux-2.1.9
		>=sys-libs/libsemanage-2.1
		>=sec-policy/selinux-sssd-2.20120725-r9
	)
	>=net-dns/bind-tools-9.9[gssapi]
	>=dev-libs/cyrus-sasl-2.1.25-r3[kerberos]
	>=sys-apps/dbus-1.6
	nls? ( >=sys-devel/gettext-0.18 )
	virtual/libintl
	netlink? ( dev-libs/libnl:3 )
	"

RDEPEND="${COMMON_DEP}
	|| ( <=sys-libs/glibc-2.16.9999 >=sys-libs/glibc-2.17[nscd] )
	"
DEPEND="${COMMON_DEP}
	test? ( dev-libs/check )
	manpages? (
		>=dev-libs/libxslt-1.1.26
		app-text/docbook-xml-dtd:4.4
		)
	doc? ( app-doc/doxygen )"

CONFIG_CHECK="~KEYS"

PATCHES=(
		"${FILESDIR}"/${PN}-1.9.6-fix-init.patch
)

pkg_setup(){
	use python && python-single-r1_pkg_setup
	linux-info_pkg_setup
}

src_prepare() {
	autotools-utils_src_prepare
}

src_configure(){
	local myeconfargs=(
		--localstatedir="${EPREFIX}"/var
		--enable-nsslibdir="${EPREFIX}"/$(get_libdir)
		--with-plugin-path="${EPREFIX}"/usr/$(get_libdir)/sssd
		--enable-pammoddir="${EPREFIX}"/$(getpam_mod_dir)
		--with-ldb-lib-dir="${EPREFIX}"/usr/$(get_libdir)/samba/ldb
		--without-nscd
		--with-unicode-lib="glib2"
		--disable-rpath
		--enable-silent-rules
		--sbindir=/usr/sbin
		$(use_with selinux)
		$(use_with selinux semanage)
		$(use_with python python-bindings)
		$(use_enable locator krb5-locator-plugin)
		$(use_enable nls )
		$(use_with netlink libnl)
		$(use_with manpages)
		$(use_with sudo)
		$(use_with autofs)
		$(use_with ssh)
		--with-crypto="libcrypto"
		--with-initscript="sysv"
		)

	autotools-utils_src_configure
}

src_install(){
	autotools-utils_src_install
	use python && python_optimize

	insinto /etc/sssd
	insopts -m600
	doins "${S}"/src/examples/sssd-example.conf

	insinto /etc/logrotate.d
	insopts -m644
	newins "${S}"/src/examples/logrotate sssd

	newconfd "${FILESDIR}"/sssd.conf sssd

	systemd_dounit "${FILESDIR}/${PN}.service"

}

src_test() {
	autotools-utils_src_test
}

pkg_postinst(){
	elog "You must set up sssd.conf (default installed into /etc/sssd)"
	elog "and (optionally) configuration in /etc/pam.d in order to use SSSD"
	elog "features. Please see howto in	http://fedorahosted.org/sssd/wiki/HOWTO_Configure_1_0_2"
}
