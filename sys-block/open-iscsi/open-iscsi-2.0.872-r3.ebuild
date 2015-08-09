# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit versionator linux-info eutils flag-o-matic toolchain-funcs

DESCRIPTION="Open-iSCSI is a high performance, transport independent, multi-platform implementation of RFC3720"
HOMEPAGE="http://www.open-iscsi.org/"
MY_PV="${PN}-$(replace_version_separator 2 "-" $MY_PV)"
SRC_URI="http://www.open-iscsi.org/bits/${MY_PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug slp"
DEPEND="slp? ( net-libs/openslp )"
RDEPEND="${DEPEND}
	virtual/udev
	sys-fs/lsscsi
	sys-apps/util-linux"

S="${WORKDIR}/${MY_PV}"

pkg_setup() {
	linux-info_pkg_setup

	if kernel_is -lt 2 6 16; then
		die "Sorry, your kernel must be 2.6.16-rc5 or newer!"
	fi

	# Needs to be done, as iscsid currently only starts, when having the iSCSI
	# support loaded as module. Kernel builtion options don't work. See this for
	# more information:
	# http://groups.google.com/group/open-iscsi/browse_thread/thread/cc10498655b40507/fd6a4ba0c8e91966
	# If there's a new release, check whether this is still valid!
	CONFIG_CHECK_MODULES="SCSI_ISCSI_ATTRS ISCSI_TCP"
	if linux_config_exists; then
		for module in ${CONFIG_CHECK_MODULES}; do
			linux_chkconfig_module ${module} || ewarn "${module} needs to be built as module (builtin doesn't work)"
		done
	fi
}

src_prepare() {
	export EPATCH_OPTS="-d${S}"
	epatch "${FILESDIR}"/${PN}-2.0.872-makefile-cleanup.patch
	epatch "${FILESDIR}"/${P}-glibc212.patch
	epatch "${FILESDIR}"/${P}-dont-call-configure.patch
	epatch "${FILESDIR}"/${P}-ldflags.patch
	epatch "${FILESDIR}"/${P}-isns-slp.patch
	epatch "${FILESDIR}"/${PN}-2.0.872-makefile-cleanup-pass2.patch
}

src_configure() {
	cd utils/open-isns || die
	econf $(use_with slp)
}

src_compile() {
	use debug && append-flags -DDEBUG_TCP -DDEBUG_SCSI

	einfo "Building userspace"
	local SLP_LIBS
	use slp && SLP_LIBS="-lslp"
	cd "${S}" && \
	KSRC="${KV_DIR}" CFLAGS="" \
	emake \
		OPTFLAGS="${CFLAGS}" SLP_LIBS="${SLP_LIBS}" \
		AR="$(tc-getAR)" CC="$(tc-getCC)" \
		user \
		|| die "emake failed"
}

src_install() {
	einfo "Installing userspace"
	dosbin usr/iscsid usr/iscsiadm usr/iscsistart || die

	einfo "Installing utilities"
	dosbin utils/iscsi-iname utils/iscsi_discovery || die

	einfo "Installing docs"
	doman doc/*[1-8] || die
	dodoc README THANKS || die
	docinto test || die
	dodoc test/* || die

	einfo "Installing configuration"
	insinto /etc/iscsi
	doins etc/iscsid.conf || die
	newins "${FILESDIR}"/initiatorname.iscsi initiatorname.iscsi.example || die
	insinto /etc/iscsi/ifaces
	doins etc/iface.example || die

	newconfd "${FILESDIR}"/${P}-conf.d iscsid || die
	newinitd "${FILESDIR}"/${P}-init.d-r1 iscsid || die

	# udev pieces
	insinto /etc/udev/scripts
	doins "${FILESDIR}"/iscsidev.sh
	insinto /lib/udev/rules.d
	doins "${FILESDIR}"/99-iscsi.rules

	keepdir /var/db/iscsi
	fperms 700 /var/db/iscsi || die
	fperms 600 /etc/iscsi/iscsid.conf || die
}

pkg_postinst() {
	in='/etc/iscsi/initiatorname.iscsi'
	if [ ! -f "${ROOT}${in}" -a -f "${ROOT}${in}.example" ]; then
		cp -f "${ROOT}${in}.example" "${ROOT}${in}"
	fi
}
