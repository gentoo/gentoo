# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit bsdmk freebsd flag-o-matic

DESCRIPTION="FreeBSD kernel sources"
SLOT="${RV}"
KEYWORDS="~amd64-fbsd ~sparc-fbsd ~x86-fbsd"

IUSE="symlink"

SRC_URI="mirror://gentoo/${SYS}.tar.bz2
	http://dev.gentoo.org/~naota/patch/${P}-en-13-03.patch"

RDEPEND="=sys-freebsd/freebsd-mk-defs-${RV}*"
DEPEND=""

RESTRICT="strip binchecks"

S="${WORKDIR}/sys"

PATCHES=( "${FILESDIR}/${PN}-9.0-disable-optimization.patch"
	"${FILESDIR}/${PN}-9.1-gentoo.patch"
	"${FILESDIR}/${PN}-6.0-flex-2.5.31.patch"
	"${FILESDIR}/${PN}-6.1-ntfs.patch"
	"${FILESDIR}/${PN}-7.1-types.h-fix.patch"
	"${FILESDIR}/${PN}-8.0-subnet-route-pr40133.patch"
	"${FILESDIR}/${PN}-7.1-includes.patch"
	"${FILESDIR}/${PN}-9.0-sysctluint.patch"
	"${FILESDIR}/${PN}-7.0-tmpfs_whiteout_stub.patch"
	"${FILESDIR}/${PN}-9.1-cve-2013-3266.patch"
	"${FILESDIR}/${PN}-9.1-mmap.patch"
	"${FILESDIR}/${PN}-9.1-nfsserver.patch"
	"${DISTDIR}/${PN}-9.1-en-13-03.patch"
	"${FILESDIR}/${PN}-9.1-cve-2013-3077.patch"
	"${FILESDIR}/${PN}-9.1-cve-2013-5209.patch"
	"${FILESDIR}/${PN}-9.1-cve-2013-5691.patch"
	"${FILESDIR}/${PN}-9.1-cve-2013-5710.patch"
	"${FILESDIR}/${PN}-9.1-cve-2014-1453.patch"
	"${FILESDIR}/${PN}-9.1-random.patch"
	"${FILESDIR}/${PN}-9.1-mmap-2014.patch"
	"${FILESDIR}/${PN}-9.1-tcp.patch"
	"${FILESDIR}/${PN}-9.1-ciss.patch"
	"${FILESDIR}/${PN}-9.1-exec.patch"
	"${FILESDIR}/${PN}-9.1-ktrace.patch" )

src_unpack() {
	freebsd_src_unpack

	# This replaces the gentoover patch, it doesn't need reapply every time.
	sed -i -e 's:^REVISION=.*:REVISION="'${PVR}'":' \
		-e 's:^BRANCH=.*:BRANCH="Gentoo":' \
		-e 's:^VERSION=.*:VERSION="${TYPE} ${BRANCH} ${REVISION}":' \
		"${S}/conf/newvers.sh"

	# __FreeBSD_cc_version comes from FreeBSD's gcc.
	# on 9.0-RELEASE it's 900001.
	sed -e "s:-D_KERNEL:-D_KERNEL -D__FreeBSD_cc_version=900001:g" \
		-i "${S}/conf/kern.pre.mk" \
		-i "${S}/conf/kmod.mk" || die "Couldn't set __FreeBSD_cc_version"

	# Remove -Werror
	sed -e "s:-Werror:-Wno-error:g" \
		-i "${S}/conf/kern.pre.mk" \
		-i "${S}/conf/kmod.mk" || die
}

src_compile() {
	einfo "Nothing to compile.."
}

src_install() {
	insinto "/usr/src/sys-${RV}"
	doins -r "${S}/"*
}

pkg_postinst() {
	if [[ ! -L "${ROOT}/usr/src/sys" ]]; then
		einfo "/usr/src/sys symlink doesn't exist; creating symlink to sys-${RV}..."
		ln -sf "sys-${RV}" "${ROOT}/usr/src/sys" || \
			eerror "Couldn't create ${ROOT}/usr/src/sys symlink."
	elif use symlink; then
		einfo "Updating /usr/src/sys symlink to sys-${RV}..."
		rm "${ROOT}/usr/src/sys" || \
			eerror "Couldn't remove previous symlinks, please fix manually."
		ln -sf "sys-${RV}" "${ROOT}/usr/src/sys" || \
			eerror "Couldn't create ${ROOT}/usr/src/sys symlink."
	fi

	if use sparc-fbsd ; then
		ewarn "WARNING: kldload currently causes kernel panics"
		ewarn "on sparc64. This is probably a gcc-4.1 issue, but"
		ewarn "we need gcc-4.1 to compile the kernel correctly :/"
		ewarn "Please compile all modules you need into the kernel"
	fi
}
