# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true
AUTOTOOLS_IN_SOURCE_BUILD=true

inherit autotools-utils linux-info multilib systemd toolchain-funcs

PATCH_VER=0
[[ -n ${PATCH_VER} ]] && \
	PATCHSET_URI="https://dev.gentoo.org/~dlan/distfiles/${P}-patches-${PATCH_VER}.tar.lzma"

DESCRIPTION="Kernel based automounter"
HOMEPAGE="http://www.linux-consulting.com/Amd_AutoFS/autofs.html"
SRC_URI="
	mirror://kernel/linux/daemons/${PN}/v5/${P}.tar.xz
	${PATCHSET_URI}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="-dmalloc hesiod ldap +libtirpc mount-locking sasl"

# USE="sasl" adds SASL support to the LDAP module which will not be build. If
# SASL support should be available, please add "ldap" to the USE flags.
REQUIRED_USE="sasl? ( ldap )"

# currently, sasl code assumes the presence of kerberosV
RDEPEND=">=sys-apps/util-linux-2.20
	dmalloc? ( dev-libs/dmalloc[threads] )
	hesiod? ( net-dns/hesiod )
	ldap? ( >=net-nds/openldap-2.0
		sasl? (
			dev-libs/cyrus-sasl
			dev-libs/libxml2
			virtual/krb5
		)
	)
	libtirpc? ( net-libs/libtirpc )"

DEPEND="${RDEPEND}
	sys-devel/flex
	virtual/yacc"

CONFIG_CHECK="~AUTOFS4_FS"

src_prepare() {
	# Upstream's patchset
	if [[ -n ${PATCH_VER} ]]; then
		EPATCH_SUFFIX="patch" \
			epatch "${WORKDIR}"/patches
	fi

	sed -i -e "s:/usr/bin/kill:/bin/kill:" samples/autofs.service.in || die #bug #479492
	autotools-utils_src_prepare
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
		$(use_with hesiod)
		$(use_enable mount-locking)
		--disable-ext-env
		--enable-sloppy-mount # bug #453778
		--enable-force-shutdown
		--enable-ignore-busy
		--with-systemd="$(systemd_get_unitdir)" #bug #479492
		RANLIB="$(type -P $(tc-getRANLIB))" # bug #483716
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile DONTSTRIP=1
}

src_install() {
	autotools-utils_src_install

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
		elog "${EROOT}usr/share/doc/${P}/patches."
		elog "For further instructions how to patch the kernel, please refer to"
		elog "${EROOT}usr/share/doc/${P}/INSTALL."
		elog
	fi
	elog "If you plan on using autofs for automounting remote NFS mounts,"
	elog "please check that both portmap (or rpcbind) and rpc.statd/lockd"
	elog "are running."
}
