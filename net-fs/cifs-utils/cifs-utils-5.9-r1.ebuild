# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/cifs-utils/cifs-utils-5.9-r1.ebuild,v 1.13 2013/10/22 10:46:10 polynomial-c Exp $

EAPI=4

inherit eutils confutils linux-info

DESCRIPTION="Tools for Managing Linux CIFS Client Filesystems"
HOMEPAGE="http://wiki.samba.org/index.php/LinuxCIFS_utils"
SRC_URI="ftp://ftp.samba.org/pub/linux-cifs/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~arm-linux ~x86-linux"
IUSE="ads +caps caps-ng creds"

DEPEND="!net-fs/mount-cifs
	!<net-fs/samba-3.6_rc1
	ads? ( sys-libs/talloc virtual/krb5 sys-apps/keyutils )
	caps? ( sys-libs/libcap )
	caps-ng? ( sys-libs/libcap-ng )
	creds? ( sys-apps/keyutils )"
RDEPEND="${DEPEND}"

REQUIRED_USE="^^ ( caps caps-ng )"

DOCS="doc/linux-cifs-client-guide.odt"

pkg_setup() {
	linux-info_pkg_setup

	confutils_use_conflict caps caps-ng
	if ! linux_config_exists || ! linux_chkconfig_present CIFS; then
		ewarn "You must enable CIFS support in your kernel config, "
		ewarn "to be able to mount samba shares. You can find it at"
		ewarn
		ewarn "  File systems"
		ewarn "	Network File Systems"
		ewarn "			CIFS support"
		ewarn
		ewarn "and recompile your kernel ..."
	fi
}

src_prepare() {
	# bug #459040
	epatch "${FILESDIR}"/${P}-set-parsed_info-got_user-when-a-cred-file.patch
}

src_configure() {
	ROOTSBINDIR="${EPREFIX}"/sbin \
	econf \
		$(use_enable ads cifsupcall) \
		$(use_with caps libcap) \
		$(use_with caps-ng libcap-ng) \
		$(use_enable creds cifscreds) \
		--with-libcap-ng=$(use caps-ng && echo 'yes' || echo 'no') \
		--disable-cifsidmap \
		--disable-cifsacl
}

src_install() {
	default

	# remove empty directories
	find "${ED}" -type d -print0 | xargs --null rmdir \
		--ignore-fail-on-non-empty &>/dev/null
}

pkg_postinst() {
	# Inform about set-user-ID bit of mount.cifs
	ewarn "setuid use flag was dropped due to multiple security implications"
	ewarn "such as CVE-2009-2948, CVE-2011-3585 and CVE-2012-1586"
	ewarn "You are free to set setuid flags by yourself"

	# Inform about upcall usage
	if use ads ; then
		ewarn "Using mount.cifs in combination with keyutils"
		ewarn "in order to mount DFS shares, you need to add"
		ewarn "the following line to /etc/request-key.conf:"
		ewarn "  create dns_resolver * * /usr/sbin/cifs.upcall %k"
		ewarn "Otherwise, your DFS shares will not work properly."
	fi
}
