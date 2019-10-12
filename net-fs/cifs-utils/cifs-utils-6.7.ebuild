# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils linux-info multilib pam

DESCRIPTION="Tools for Managing Linux CIFS Client Filesystems"
HOMEPAGE="https://wiki.samba.org/index.php/LinuxCIFS_utils"
SRC_URI="https://ftp.samba.org/pub/linux-cifs/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-linux"
IUSE="+acl +ads +caps +caps-ng creds pam"

RDEPEND="
	!net-fs/mount-cifs
	!<net-fs/samba-3.6_rc1
	sys-apps/keyutils
	ads? (
		sys-libs/talloc
		virtual/krb5
	)
	caps? ( !caps-ng? ( sys-libs/libcap ) )
	caps? ( caps-ng? ( sys-libs/libcap-ng ) )
	pam? ( sys-libs/pam )
"
DEPEND="${RDEPEND}"
PDEPEND="
	acl? ( >=net-fs/samba-4.0.0_alpha1 )
"

REQUIRED_USE="acl? ( ads )"

DOCS="doc/linux-cifs-client-guide.odt"

PATCHES=(
	"${FILESDIR}/${P}-talloc.patch"
)

pkg_setup() {
	linux-info_pkg_setup

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
	default

	if has_version app-crypt/heimdal ; then
		# https://bugs.gentoo.org/612584
		eapply "${FILESDIR}/${PN}-6.7-heimdal.patch"
	fi

	eautoreconf
}

src_configure() {
	ROOTSBINDIR="${EPREFIX}"/sbin \
	econf \
		$(use_enable acl cifsacl cifsidmap) \
		$(use_enable ads cifsupcall) \
		$(use caps && use_with !caps-ng libcap || echo --without-libcap) \
		$(use caps && use_with caps-ng libcap-ng || echo --without-libcap-ng) \
		$(use_enable creds cifscreds) \
		$(use_enable pam) \
		$(use_with pam pamdir $(getpam_mod_dir))
}

src_install() {
	default

	# remove empty directories
	find "${ED}" -type d -print0 | xargs --null rmdir \
		--ignore-fail-on-non-empty &>/dev/null

	if use acl ; then
		dodir /etc/cifs-utils
		dosym /usr/$(get_libdir)/cifs-utils/idmapwb.so \
			/etc/cifs-utils/idmap-plugin
		dodir /etc/request-key.d
		echo 'create cifs.idmap * * /usr/sbin/cifs.idmap %k' \
			> "${ED}/etc/request-key.d/cifs.idmap.conf"
	fi

	if use ads ; then
		dodir /etc/request-key.d
		echo 'create dns_resolver * * /usr/sbin/cifs.upcall %k' \
			> "${ED}/etc/request-key.d/cifs.upcall.conf"
		echo 'create cifs.spnego * * /usr/sbin/cifs.upcall %k' \
			> "${ED}/etc/request-key.d/cifs.spnego.conf"
	fi
}

pkg_postinst() {
	# Inform about set-user-ID bit of mount.cifs
	ewarn "setuid use flag was dropped due to multiple security implications"
	ewarn "such as CVE-2009-2948, CVE-2011-3585 and CVE-2012-1586"
	ewarn "You are free to set setuid flags by yourself"

	# Inform about upcall usage
	if use acl ; then
		einfo "The cifs.idmap utility has been enabled by creating the"
		einfo "configuration file /etc/request-key.d/cifs.idmap.conf"
		einfo "This enables you to get and set CIFS acls."
	fi

	if use ads ; then
		einfo "The cifs.upcall utility has been enabled by creating the"
		einfo "configuration file /etc/request-key.d/cifs.upcall.conf"
		einfo "This enables you to mount DFS shares."
	fi
}
