# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit versionator linux-info eutils flag-o-matic toolchain-funcs udev

MY_P="${PN}-$(replace_version_separator 2 "-")"

DESCRIPTION="Open-iSCSI is a high performance, transport independent, multi-platform implementation of RFC3720"
HOMEPAGE="http://www.open-iscsi.org/"
SRC_URI="http://www.open-iscsi.org/bits/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc x86"
IUSE="debug slp"

DEPEND="slp? ( net-libs/openslp )"
RDEPEND="${DEPEND}
	sys-fs/lsscsi
	sys-apps/util-linux"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	linux-info_pkg_setup

	if kernel_is -lt 2 6 16; then
		die "Sorry, your kernel must be 2.6.16-rc5 or newer!"
	fi

	# Needs to be done, as iscsid currently only starts, when having the iSCSI
	# support loaded as module. Kernel builtion options don't work. See this for
	# more information:
	# https://groups.google.com/group/open-iscsi/browse_thread/thread/cc10498655b40507/fd6a4ba0c8e91966
	# If there's a new release, check whether this is still valid!
	CONFIG_CHECK_MODULES="SCSI_ISCSI_ATTRS ISCSI_TCP"
	if linux_config_exists; then
		for module in ${CONFIG_CHECK_MODULES}; do
			linux_chkconfig_module ${module} || ewarn "${module} needs to be built as module (builtin doesn't work)"
		done
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-Makefiles.patch
	epatch "${FILESDIR}"/${P}-memset.patch

	sed -i -e 's:^\(iscsid.startup\)\s*=.*:\1 = /usr/sbin/iscsid:' etc/iscsid.conf || die
}

src_configure() {
	use debug && append-cppflags -DDEBUG_TCP -DDEBUG_SCSI
	append-lfs-flags

	cd utils/open-isns || die

	# SSL (--with-security) is broken
	econf $(use_with slp) \
		--without-security
}

src_compile() {
	# Stuffing CPPFLAGS into CFLAGS isn't entirely correct, but the build
	# is messed up already here, so it's not making it that much worse.
	KSRC="${KV_DIR}" CFLAGS="" \
	emake \
		OPTFLAGS="${CFLAGS} ${CPPFLAGS}" \
		AR="$(tc-getAR)" CC="$(tc-getCC)" \
		user
}

src_install() {
	emake DESTDIR="${ED}" sbindir="/usr/sbin" install

	dodoc README THANKS

	docinto test/
	dodoc test/*

	insinto /etc/iscsi
	newins "${FILESDIR}"/initiatorname.iscsi initiatorname.iscsi.example

	# udev pieces
	udev_dorules "${FILESDIR}"/99-iscsi.rules
	exeinto /etc/udev/scripts
	doexe "${FILESDIR}"/iscsidev.sh

	newconfd "${FILESDIR}"/iscsid-conf.d iscsid
	newinitd "${FILESDIR}"/iscsid-init.d iscsid

	keepdir /var/db/iscsi
	fperms 700 /var/db/iscsi
	fperms 600 /etc/iscsi/iscsid.conf
}
