# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools linux-info systemd

DESCRIPTION="NFS client and server daemons"
HOMEPAGE="http://linux-nfs.org/ https://git.linux-nfs.org/?p=steved/nfs-utils.git"

if [[ ${PV} == *_rc* ]] ; then
	MY_PV="$(ver_rs 1- -)"
	SRC_URI="http://git.linux-nfs.org/?p=steved/nfs-utils.git;a=snapshot;h=refs/tags/${PN}-${MY_PV};sf=tgz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${PN}-${MY_PV}"
else
	SRC_URI="https://downloads.sourceforge.net/nfs/${P}.tar.bz2"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="caps junction kerberos ldap +libmount +nfsv3 +nfsv4 sasl selinux tcpd +uuid"
REQUIRED_USE="|| ( nfsv3 nfsv4 ) kerberos? ( nfsv4 )"
# bug #315573
RESTRICT="test"

# kth-krb doesn't provide the right include
# files, and nfs-utils doesn't build against heimdal either,
# so don't depend on virtual/krb.
# (04 Feb 2005 agriffis)
COMMON_DEPEND="
	dev-libs/libxml2
	net-libs/libtirpc:=
	sys-fs/e2fsprogs
	dev-db/sqlite:3
	dev-libs/libevent:=
	caps? ( sys-libs/libcap )
	ldap? (
		net-nds/openldap:=
		sasl? (
			app-crypt/mit-krb5
			dev-libs/cyrus-sasl:2
		)
	)
	libmount? ( sys-apps/util-linux )
	nfsv3? ( >=net-nds/rpcbind-0.2.4 )
	nfsv4? (
		>=sys-apps/keyutils-1.5.9:=
		sys-fs/lvm2
		kerberos? (
			>=net-libs/libtirpc-0.2.4-r1[kerberos]
			app-crypt/mit-krb5
		)
	)
	tcpd? ( sys-apps/tcp-wrappers )
	uuid? ( sys-apps/util-linux )"
DEPEND="${COMMON_DEPEND}
	elibc_musl? ( sys-libs/queue-standalone )
"
RDEPEND="${COMMON_DEPEND}
	!net-libs/libnfsidmap
	selinux? (
		sec-policy/selinux-rpc
		nfsv3? ( sec-policy/selinux-rpcbind )
	)
"
BDEPEND="
	net-libs/rpcsvc-proto
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.2-no-werror.patch
	"${FILESDIR}"/${PN}-udev-sysctl.patch
	"${FILESDIR}"/${PN}-2.6.4-C99-inline.patch
)

pkg_setup() {
	linux-info_pkg_setup

	if use nfsv4 && linux_config_exists && ! linux_chkconfig_present CRYPTO_MD5 ; then
		ewarn "Your NFS server will be unable to track clients across server restarts!"
		ewarn "Please enable CONFIG_CRYPTO_MD5 in your kernel to"
		ewarn "support the legacy, in-kernel client tracker."
	fi
}

src_prepare() {
	default

	sed \
		-e "/^sbindir/s:= := \"${EPREFIX}\":g" \
		-i utils/*/Makefile.am || die

	eautoreconf
}

src_configure() {
	# Our DEPEND forces this.
	export libsqlite3_cv_is_recent=yes
	export ac_cv_header_keyutils_h=$(usex nfsv4)

	# SASL is consumed in a purely automagic way
	export ac_cv_header_sasl_h=no
	export ac_cv_header_sasl_sasl_h=$(usex sasl)

	local myeconfargs=(
		--disable-static
		--with-statedir="${EPREFIX}"/var/lib/nfs
		--enable-tirpc
		--with-tirpcinclude="${ESYSROOT}"/usr/include/tirpc/
		--with-pluginpath="${EPREFIX}"/usr/$(get_libdir)/libnfsidmap
		--with-rpcgen
		--with-systemd="$(systemd_get_systemunitdir)"
		--without-gssglue
		$(use_enable caps)
		--enable-ipv6
		$(use_enable junction)
		$(use_enable kerberos gss)
		$(use_enable kerberos svcgss)
		$(use_enable ldap)
		$(use_enable libmount libmount-mount)
		$(use_enable nfsv4)
		$(use_enable nfsv4 nfsdcld)
		$(use_enable nfsv4 nfsdcltrack)
		$(use_enable nfsv4 nfsv41)
		$(use_enable nfsv4 nfsv4server)
		$(use_enable uuid)
		$(use_with kerberos krb5 "${ESYSROOT}"/usr)
		$(use_with tcpd tcp-wrappers)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	# Remove compiled files bundled in the tarball
	emake clean

	default
}

src_install() {
	default
	rm linux-nfs/Makefile* || die
	dodoc -r linux-nfs README

	# Don't overwrite existing xtab/etab, install the original
	# versions somewhere safe...  more info in pkg_postinst
	keepdir /var/lib/nfs/{,sm,sm.bak}
	mv "${ED}"/var/lib/nfs "${ED}"/usr/$(get_libdir)/ || die

	# Install some client-side binaries in /sbin
	dodir /sbin
	mv "${ED}"/usr/sbin/rpc.statd "${ED}"/sbin/ || die

	if use nfsv4 ; then
		insinto /etc
		doins support/nfsidmap/idmapd.conf

		# Install a config file for idmappers in newer kernels. bug #415625
		insinto /etc/request-key.d
		echo 'create id_resolver * * /usr/sbin/nfsidmap -t 600 %k %d' > id_resolver.conf
		doins id_resolver.conf
	fi

	insinto /etc
	doins "${FILESDIR}"/exports
	keepdir /etc/exports.d

	local f list=()
	if use nfsv4 ; then
		list+=( rpc.idmapd rpc.pipefs )
		use kerberos && list+=( rpc.gssd rpc.svcgssd )
	fi

	local sedexp=( -e '#placehoder' )
	use nfsv3 || sedexp+=( -e '/need portmap/d' )

	mkdir -p "${T}/init.d" || die
	for f in nfs nfsclient rpc.statd "${list[@]}" ; do
		sed "${sedexp[@]}" "${FILESDIR}/${f}.initd" > "${T}/init.d/${f}" || die
		doinitd "${T}/init.d/${f}"
	done

	local systemd_systemunitdir="$(systemd_get_systemunitdir)"
	sed -i \
		-e 's:/usr/sbin/rpc.statd:/sbin/rpc.statd:' \
		"${ED}${systemd_systemunitdir}"/* || die

	# Remove legacy service if not requested (as it will be broken without rpcbind)
	if ! use nfsv3; then
		rm "${ED}${systemd_systemunitdir}/nfs-server.service" || die
	fi

	# bug #368505
	keepdir /var/lib/nfs
	# bug #603628
	keepdir /var/lib/nfs/v4recovery

	# No static archives
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	# Install default xtab and friends if there's none existing.  In
	# src_install we put them in /usr/lib/nfs for safe-keeping, but
	# the daemons actually use the files in /var/lib/nfs.  #30486
	local f
	for f in "${EROOT}"/usr/$(get_libdir)/nfs/*; do
		[[ -e ${EROOT}/var/lib/nfs/${f##*/} ]] && continue
		einfo "Copying default ${f##*/} from ${EPREFIX}/usr/$(get_libdir)/nfs to ${EPREFIX}/var/lib/nfs"
		cp -pPR "${f}" "${EROOT}"/var/lib/nfs/
	done
}
