# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit autotools bash-completion-r1 linux-info pam python-single-r1

DESCRIPTION="Tools for Managing Linux CIFS Client Filesystems"
HOMEPAGE="https://wiki.samba.org/index.php/LinuxCIFS_utils https://git.samba.org/cifs-utils.git/?p=cifs-utils.git"
SRC_URI="https://ftp.samba.org/pub/linux-cifs/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86 ~x86-linux"
IUSE="+acl +ads +caps creds pam +python systemd"

RDEPEND="
	ads? (
		sys-apps/keyutils:=
		sys-libs/talloc
		virtual/krb5
	)
	caps? ( sys-libs/libcap-ng )
	creds? ( sys-apps/keyutils:= )
	pam? (
		sys-apps/keyutils:=
		sys-libs/pam
	)
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="dev-python/docutils"
PDEPEND="
	acl? ( >=net-fs/samba-4.0.0_alpha1 )
"

REQUIRED_USE="
	acl? ( ads )
	python? ( ${PYTHON_REQUIRED_USE} )
"

DOCS="doc/linux-cifs-client-guide.odt"

PATCHES=(
	"${FILESDIR}/${PN}-6.12-ln_in_destdir.patch" #766594
	"${FILESDIR}/${PN}-6.15-musl.patch"
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

	use python && python-single-r1_pkg_setup
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
	local myeconfargs=(
		--enable-man
		--enable-smbinfo
		$(use_enable acl cifsacl cifsidmap)
		$(use_enable ads cifsupcall)
		$(use_with caps libcap)
		$(use_enable creds cifscreds)
		$(use_enable pam)
		$(use_with pam pamdir $(getpam_mod_dir))
		$(use_enable python pythontools)
		# mount.cifs can get passwords from systemd
		$(use_enable systemd)
	)
	ROOTSBINDIR="${EPREFIX}"/sbin \
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# remove empty directories
	find "${ED}" -type d -empty -delete || die

	if use acl ; then
		dodir /etc/cifs-utils
		dosym ../../usr/$(get_libdir)/cifs-utils/idmapwb.so \
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

	dobashcomp bash-completion/smbinfo
	use python && python_fix_shebang "${ED}"
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
