# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info systemd toolchain-funcs

DESCRIPTION="Kernel based automounter"
HOMEPAGE="https://web.archive.org/web/*/http://www.linux-consulting.com/Amd_AutoFS/autofs.html"
SRC_URI="https://www.kernel.org/pub/linux/daemons/${PN}/v5/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="-dmalloc ldap +libtirpc mount-locking sasl systemd"

# currently, sasl code assumes the presence of kerberosV
RDEPEND=">=sys-apps/util-linux-2.20
	dmalloc? ( dev-libs/dmalloc[threads] )
	ldap? ( >=net-nds/openldap-2.0
		sasl? (
			dev-libs/cyrus-sasl
			dev-libs/libxml2
			virtual/krb5
		)
	)
	systemd? ( sys-apps/systemd )
	libtirpc? ( net-libs/libtirpc )
	!libtirpc? ( elibc_glibc? ( sys-libs/glibc[rpc(-)] ) )
"
DEPEND="${RDEPEND}
	libtirpc? ( net-libs/rpcsvc-proto )
"
BDEPEND="
	sys-devel/flex
	virtual/yacc
"

pkg_setup() {
	linux-info_pkg_setup

	local CONFIG_CHECK

	if kernel_is -ge 4 18; then
		CONFIG_CHECK="~AUTOFS_FS"
	else
		CONFIG_CHECK="~AUTOFS4_FS"
	fi

	check_extra_config
}

src_prepare() {
	sed -i	-e "s:/usr/bin/kill:/bin/kill:" samples/autofs.service.in || die # bug #479492
	sed -i	-e "/^EnvironmentFile/d"        samples/autofs.service.in || die # bug #592334

	# Install samples including autofs.service
	sed -i -e "/^SUBDIRS/s/$/ samples/g" Makefile.rules || die

	default
}

src_configure() {
	# bug #483716
	tc-export AR
	# --with-confdir is for bug #361481
	# --with-mapdir is for bug #385113
	local myeconfargs=(
		--with-confdir=/etc/conf.d
		--with-mapdir=/etc/autofs
		$(use_with dmalloc)
		$(use_with ldap openldap)
		$(use_with libtirpc)
		$(use_with sasl)
		$(use_enable mount-locking)
		$(use_with systemd systemd $(systemd_get_systemunitdir)) # bug #479492
		--without-hesiod
		--disable-ext-env
		--enable-sloppy-mount # bug #453778
		--enable-force-shutdown
		--enable-ignore-busy
		RANLIB="$(type -P $(tc-getRANLIB))" # bug #483716
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	rmdir "${D}"/run

	if kernel_is -lt 2 6 30; then
		# kernel patches
		docinto patches
		dodoc patches/${PN}4-2.6.??{,.?{,?}}-v5-update-????????.patch
	fi
	newinitd "${FILESDIR}"/autofs5.initd autofs
	insinto etc/autofs
	newins "${FILESDIR}"/autofs5-auto.master auto.master
}

pkg_postinst() {
	if kernel_is -lt 2 6 30; then
		elog "This version of ${PN} requires a kernel with autofs4 supporting"
		elog "protocol version 5.00. Patches for kernels older than 2.6.30 have"
		elog "been installed into"
		elog "${EROOT}/usr/share/doc/${P}/patches."
		elog "For further instructions how to patch the kernel, please refer to"
		elog "${EROOT}/usr/share/doc/${P}/INSTALL."
		elog
	fi
	elog "If you plan on using autofs for automounting remote NFS mounts,"
	elog "please check that both portmap (or rpcbind) and rpc.statd/lockd"
	elog "are running."
}
