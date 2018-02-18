# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic multilib systemd

DESCRIPTION="NFS client and server daemons"
HOMEPAGE="http://linux-nfs.org/"

if [[ "${PV}" = *_rc* ]] ; then
	inherit versionator
	MY_PV="$(replace_all_version_separators -)"
	SRC_URI="http://git.linux-nfs.org/?p=steved/nfs-utils.git;a=snapshot;h=refs/tags/${PN}-${MY_PV};sf=tgz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${PN}-${MY_PV}"
else
	SRC_URI="mirror://sourceforge/nfs/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="caps ipv6 kerberos ldap +libmount nfsdcld +nfsidmap +nfsv4 nfsv41 selinux tcpd +uuid"
REQUIRED_USE="kerberos? ( nfsv4 )"
RESTRICT="test" #315573

# kth-krb doesn't provide the right include
# files, and nfs-utils doesn't build against heimdal either,
# so don't depend on virtual/krb.
# (04 Feb 2005 agriffis)
DEPEND_COMMON="
	net-libs/libtirpc:=
	>=net-nds/rpcbind-0.2.4
	sys-libs/e2fsprogs-libs
	caps? ( sys-libs/libcap )
	ldap? ( net-nds/openldap )
	libmount? ( sys-apps/util-linux )
	nfsdcld? ( >=dev-db/sqlite-3.3 )
	nfsv4? (
		dev-libs/libevent:=
		>=sys-apps/keyutils-1.5.9
		kerberos? (
			>=net-libs/libtirpc-0.2.4-r1[kerberos]
			app-crypt/mit-krb5
		)
	)
	nfsv41? (
		sys-fs/lvm2
	)
	tcpd? ( sys-apps/tcp-wrappers )
	uuid? ( sys-apps/util-linux )"
RDEPEND="${DEPEND_COMMON}
	!net-libs/libnfsidmap
	!net-nds/portmap
	!<sys-apps/openrc-0.13.9
	selinux? (
		sec-policy/selinux-rpc
		sec-policy/selinux-rpcbind
	)
"
DEPEND="${DEPEND_COMMON}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.4-mtab-sym.patch
	"${FILESDIR}"/${PN}-1.2.8-cross-build.patch
	"${FILESDIR}"/${P}-svcgssd_undefined_reference.patch #641912
)

src_prepare() {
	default

	sed \
		-e "/^sbindir/s:= := \"${EPREFIX}\":g" \
		-i utils/*/Makefile.am || die

	eautoreconf
}

src_configure() {
	export libsqlite3_cv_is_recent=yes # Our DEPEND forces this.
	export ac_cv_header_keyutils_h=$(usex nfsidmap)
	local myeconfargs=(
		--with-statedir="${EPREFIX}"/var/lib/nfs
		--enable-tirpc
		--with-tirpcinclude="${EPREFIX}"/usr/include/tirpc/
		--with-pluginpath="${EPREFIX}"/usr/$(get_libdir)/libnfsidmap
		--with-systemd="$(systemd_get_systemunitdir)"
		$(use_enable libmount libmount-mount)
		$(use_with tcpd tcp-wrappers)
		$(use_enable nfsdcld nfsdcltrack)
		$(use_enable nfsv4)
		$(use_enable nfsv41)
		$(use_enable ipv6)
		$(use_enable caps)
		$(use_enable uuid)
		$(use_enable kerberos gss)
		$(use_enable kerberos svcgss)
		--without-gssglue
	)
	econf "${myeconfargs[@]}"
}

src_compile(){
	# remove compiled files bundled in the tarball
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
	mv "${ED%/}"/var/lib/nfs "${ED%/}"/usr/$(get_libdir)/ || die

	# Install some client-side binaries in /sbin
	dodir /sbin
	mv "${ED%/}"/usr/sbin/rpc.statd "${ED%/}"/sbin/ || die

	if use nfsv4 && use nfsidmap ; then
		# Install a config file for idmappers in newer kernels. #415625
		insinto /etc/request-key.d
		echo 'create id_resolver * * /usr/sbin/nfsidmap -t 600 %k %d' > id_resolver.conf
		doins id_resolver.conf
	fi

	insinto /etc
	doins "${FILESDIR}"/exports
	keepdir /etc/exports.d

	local f list=() opt_need=""
	if use nfsv4 ; then
		opt_need="rpc.idmapd"
		list+=( rpc.idmapd rpc.pipefs )
		use kerberos && list+=( rpc.gssd rpc.svcgssd )
	fi
	for f in nfs nfsclient rpc.statd "${list[@]}" ; do
		newinitd "${FILESDIR}"/${f}.initd ${f}
	done
	newinitd "${FILESDIR}"/nfsmount.initd-1.3.1 nfsmount # Nuke after 2015/08/01
	for f in nfs nfsclient ; do
		newconfd "${FILESDIR}"/${f}.confd ${f}
	done
	sed -i \
		-e "/^NFS_NEEDED_SERVICES=/s:=.*:=\"${opt_need}\":" \
		"${ED%/}"/etc/conf.d/nfs || die #234132

	local systemd_systemunitdir="$(systemd_get_systemunitdir)"
	sed -i \
		-e 's:/usr/sbin/rpc.statd:/sbin/rpc.statd:' \
		"${ED%/}${systemd_systemunitdir}"/* || die

	keepdir /var/lib/nfs #368505
	keepdir /var/lib/nfs/v4recovery #603628

}

pkg_postinst() {
	# Install default xtab and friends if there's none existing.  In
	# src_install we put them in /usr/lib/nfs for safe-keeping, but
	# the daemons actually use the files in /var/lib/nfs.  #30486
	local f
	for f in "${EROOT%/}"/usr/$(get_libdir)/nfs/*; do
		[[ -e ${EROOT%/}/var/lib/nfs/${f##*/} ]] && continue
		einfo "Copying default ${f##*/} from ${EPREFIX}/usr/$(get_libdir)/nfs to ${EPREFIX}/var/lib/nfs"
		cp -pPR "${f}" "${EROOT%/}"/var/lib/nfs/
	done

	if systemd_is_booted; then
		if [[ ${REPLACING_VERSIONS} < 1.3.0 ]]; then
			ewarn "We have switched to upstream systemd unit files. Since"
			ewarn "they got renamed, you should probably enable the new ones."
			ewarn "You can run 'equery files nfs-utils | grep systemd'"
			ewarn "to know what services you need to enable now."
		fi
	else
		ewarn "If you use OpenRC, the nfsmount service has been replaced with nfsclient."
		ewarn "If you were using nfsmount, please add nfsclient and netmount to the"
		ewarn "same runlevel as nfsmount."
	fi
}
