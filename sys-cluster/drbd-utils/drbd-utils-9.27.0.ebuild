# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools bash-completion-r1 flag-o-matic linux-info tmpfiles udev

DESCRIPTION="mirror/replicate block-devices across a network-connection"
HOMEPAGE="https://www.linbit.com/drbd"
SRC_URI="https://pkg.linbit.com/downloads/drbd/utils/${P}.tar.gz"
S="${WORKDIR}/${P/_/}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pacemaker +udev xen"

DEPEND="
	sys-apps/keyutils
	pacemaker? ( sys-cluster/pacemaker )
	udev? ( virtual/udev )
"
RDEPEND="${DEPEND}"
BDEPEND="app-alternatives/lex"

PATCHES=(
	"${FILESDIR}"/${PN}-9.23.1-respect-flags.patch
)

pkg_setup() {
	# verify that CONFIG_BLK_DEV_DRBD is enabled in the kernel or
	# warn otherwise
	linux-info_pkg_setup
	elog "Checking for suitable kernel configuration options..."
	if linux_config_exists; then
		if ! linux_chkconfig_present BLK_DEV_DRBD; then
			ewarn "CONFIG_BLK_DEV_DRBD: is not set when it should be."
			elog "Please check to make sure these options are set correctly."
		fi
	else
		ewarn "Could not check if CONFIG_BLK_DEV_DRBD is enabled in your kernel."
		elog "Please check to make sure these options are set correctly."
	fi
}

src_prepare() {
	# Respect LDFLAGS, bug #453442
	sed -e "s/\$(CC) -o/\$(CC) \$(LDFLAGS) -o/" \
		-e "/\$(DESTDIR)\$(localstatedir)\/lock/d" \
		-i user/*/Makefile.in || die

	# Respect multilib, bug #698304
	sed -i -e "s:/lib/:/$(get_libdir)/:g" \
		Makefile.in scripts/{Makefile.in,global_common.conf,drbd.conf.example} || die
	sed -e "s:@prefix@/lib:@prefix@/$(get_libdir):" \
		-e "s:(DESTDIR)/lib:(DESTDIR)/$(get_libdir):" \
		-i user/*/Makefile.in || die
	sed -i -e "s/lib/$(get_libdir)/" scripts/drbd.service || die

	# Correct install paths (really correct this time)
	sed -i -e "s:\$(sysconfdir)/bash_completion.d:$(get_bashcompdir):" \
		scripts/Makefile.in || die

	# Don't participate in user survey, bug #360483
	sed -i -e '/usage-count/ s/yes/no/' scripts/global_common.conf || die
	sed -i -e "s:\$(sysconfdir)/udev:$(get_udevdir):" scripts/Makefile.in || die

	default
	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch, bug #863728
	# https://github.com/LINBIT/drbd-utils/issues/40
	filter-lto

	local myeconfargs=(
		--localstatedir="${EPREFIX}"/var
		# don't autodetect systemd/sysv; install systemd and use our own openrc
		--with-initscripttype=systemd
		# only used for systemdunitdir and for udevdir; the latter breaks
		# merged-usr interop
		PKG_CONFIG=/bin/false
		--with-systemdunitdir="${EPREFIX}"/usr/lib/systemd/system
		--with-bashcompletion
		--with-distro=gentoo
		--with-prebuiltman
		--without-rgmanager
		$(use_with pacemaker)
		$(use_with udev)
		$(use_with xen)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	# Only compile the tools
	emake CXXFLAGS="${CXXFLAGS}" OPTFLAGS="${CFLAGS}" tools doc
}

src_install() {
	# Only install the tools
	emake DESTDIR="${D}" install-tools install-doc

	# Install our own init script
	newinitd "${FILESDIR}"/${PN}-8.0.rc ${PN/-utils/}

	dodoc scripts/drbd.conf.example

	keepdir /var/lib/drbd
	rm -r "${ED}"/var/run || die

	# bug #698304
	dodir /lib/drbd
	local i
	for i in drbdadm-83 drbdadm-84 drbdsetup-83 drbdsetup-84; do
		dosym -r /$(get_libdir)/drbd/"${i}" /lib/drbd/"${i}"
	done

	einstalldocs
}

pkg_postinst() {
	tmpfiles_process drbd.conf

	einfo
	einfo "Please copy and gunzip the configuration file:"
	einfo "from ${EROOT}/usr/share/doc/${PF}/${PN/-utils/}.conf.example.bz2 to ${EROOT}/etc/${PN/-utils/}.conf"
	einfo "and edit it to your needs. Helpful commands:"
	einfo "man 5 drbd.conf"
	einfo "man 8 drbdsetup"
	einfo "man 8 drbdadm"
	einfo "man 8 drbddisk"
	einfo "man 8 drbdmeta"
	einfo
}
