# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils linux-info readme.gentoo systemd user udev

#MY_P="${PN}-${PV%.*}-${PV##*.}"

DESCRIPTION="An open-source TCG Software Stack (TSS) v1.1 implementation"
HOMEPAGE="http://trousers.sf.net"
SRC_URI="mirror://sourceforge/trousers/${P}.tar.gz"

LICENSE="CPL-1.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~x86"
IUSE="doc selinux" # gtk

# gtk support presently does NOT compile.
#	gtk? ( >=x11-libs/gtk+-2 )

CDEPEND=">=dev-libs/glib-2
	>=dev-libs/openssl-0.9.7:0"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-tcsd )"
# S="${WORKDIR}/${P}git"

DOCS="AUTHORS ChangeLog NICETOHAVES README TODO"

DOC_CONTENTS="
	If you have problems starting tcsd, please check permissions and
	ownership on /dev/tpm* and ~tss/system.data
"

pkg_setup() {
	# Check for driver (not sure it can be an rdep, because ot depends on the
	# version of virtual/linux-sources... Is that supported by portage?)
	linux-info_pkg_setup
	local tpm_kernel_version tpm_kernel_present tpm_module
	kernel_is ge 2 6 12 && tpm_kernel_version="yes"
	if linux_config_exists; then
		linux_chkconfig_present TCG_TPM && tpm_kernel_present="yes"
	else
		ewarn "No kernel configuration could be found."
	fi
	has_version app-crypt/tpm-emulator && tpm_module="yes"
	if [[ -n "${tpm_kernel_present}" ]]; then
		einfo "Good, you seem to have in-kernel TPM support."
	elif [[ -n "${tpm_module}" ]]; then
		einfo "Good, you seem to have TPM support with the external module."
		if [[ -n "${tpm_kernel_version}" ]]; then
			elog
			elog "Note that since you have a >=2.6.12 kernel, you could use"
			elog "the in-kernel driver instead of (CONFIG_TCG_TPM)."
		fi
	elif [[ -n "${tpm_kernel_version}" ]]; then
		eerror
		eerror "To use this package, you will have to activate TPM support"
		eerror "in your kernel configuration. That's at least CONFIG_TCG_TPM,"
		eerror "plus probably a chip specific driver (like CONFIG_TCG_ATMEL)."
		eerror
	else
		eerror
		eerror "To use this package, you should install a TPM driver."
		eerror "You can have the following options:"
		eerror "  - install app-crypt/tpm-emulator"
		eerror "  - switch to a >=2.6.12 kernel and compile the kernel module"
		eerror
	fi

	# New user/group for the daemon
	enewgroup tss
	enewuser tss -1 -1 /var/lib/tpm tss
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-nouseradd.patch
	epatch "${FILESDIR}"/${P}-build.patch
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	# econf --with-gui=$(usex gtk gtk openssl)
	econf --with-gui=openssl
}

src_install() {
	keepdir /var/lib/tpm
	default
	use doc && dodoc doc/*
	newinitd "${FILESDIR}"/tcsd.initd tcsd
	newconfd "${FILESDIR}"/tcsd.confd tcsd
	systemd_dounit "${FILESDIR}"/tcsd.service
	udev_dorules "${FILESDIR}"/61-trousers.rules
	fowners tss:tss /var/lib/tpm
	prune_libtool_files
	readme.gentoo_create_doc
}
