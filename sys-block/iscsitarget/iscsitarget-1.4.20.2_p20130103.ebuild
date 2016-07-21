# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit linux-mod eutils flag-o-matic

if [ ${PV} == "9999" ] ; then
	inherit subversion
	ESVN_REPO_URI="http://svn.code.sf.net/p/iscsitarget/code/trunk"
else
	SRC_URI="https://dev.gentoo.org/~ryao/dist/${P}.tar.gz"
	KEYWORDS="amd64 ~ppc x86"
fi

DESCRIPTION="Open Source iSCSI target with professional features"
HOMEPAGE="http://iscsitarget.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}"

MODULE_NAMES="iscsi_trgt(misc:${S}/kernel)"

pkg_setup() {
	CONFIG_CHECK="CRYPTO_CRC32C"
	ERROR_CFG="iscsitarget needs support for CRC32C in your kernel."

	kernel_is ge 2 6 14 || die "Linux 2.6.14 or newer required"

	[ ${PV} != "9999" ] && \
		{ kernel_is le 3 6 || die "Linux 3.6 is the latest supported version."; }

	linux-mod_pkg_setup
}
src_prepare() {
	if [ ${PV} != "9999" ]
	then
		# Fix build system to apply proper patches
		epatch "${FILESDIR}/${PN}-1.4.20.2_p20130103-fix-3.2-support.patch"

		# Respect LDFLAGS. Bug #365735
		epatch "${FILESDIR}/${PN}-1.4.20.2-respect-flags-v2.patch"

		# Avoid use of WRITE_SAME_16 in Linux 2.6.32 and earlier
		epatch "${FILESDIR}/${PN}-1.4.20.2_p20130103-restore-linux-2.6.32-support.patch"
	fi

	# Apply kernel-specific patches
	emake KSRC="${KERNEL_DIR}" patch || die

	epatch_user
}

src_compile() {
	emake KSRC="${KERNEL_DIR}" usr || die

	unset ARCH
	filter-ldflags -Wl,*
	emake KSRC="${KERNEL_DIR}" kernel || die
}

src_install() {
	einfo "Installing userspace"

	# Install ietd into libexec; we don't need ietd to be in the path
	# for ROOT, since it's just a service.
	exeinto /usr/libexec
	doexe usr/ietd || die

	dosbin usr/ietadm || die

	insinto /etc
	doins etc/ietd.conf etc/initiators.allow || die

	# We moved ietd in /usr/libexec, so update the init script accordingly.
	sed -e 's:/usr/sbin/ietd:/usr/libexec/ietd:' "${FILESDIR}"/ietd-init.d-2 > "${T}"/ietd-init.d
	newinitd "${T}"/ietd-init.d ietd || die
	newconfd "${FILESDIR}"/ietd-conf.d ietd || die

	# Lock down perms, per bug 198209
	fperms 0640 /etc/ietd.conf /etc/initiators.allow

	doman doc/manpages/*.[1-9] || die
	dodoc ChangeLog README RELEASE_NOTES README.initiators README.mcs README.vmware || die

	einfo "Installing kernel module"
	unset ARCH
	linux-mod_src_install || die
}
