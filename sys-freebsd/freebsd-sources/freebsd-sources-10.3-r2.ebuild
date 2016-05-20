# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit bsdmk freebsd flag-o-matic toolchain-funcs

DESCRIPTION="FreeBSD kernel sources"
SLOT="0"
LICENSE="BSD zfs? ( CDDL )"

IUSE="+build-kernel debug dtrace zfs"

# Security Advisory and Errata patches.
UPSTREAM_PATCHES=( "SA-16:18/atkbd.patch"
	"SA-16:19/sendmsg.patch"
	"EN-16:07/ipi.patch"
	"EN-16:08/zfs.patch" )

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
	SRC_URI="${SRC_URI}
		$(freebsd_upstream_patches)"
fi

EXTRACTONLY="
	sys/
	contrib/bmake/
	usr.bin/bmake/
"

RDEPEND="dtrace? ( >=sys-freebsd/freebsd-cddl-9.2_rc1 )
	=sys-freebsd/freebsd-mk-defs-${RV}*
	!sys-freebsd/virtio-kmod
	!sys-fs/fuse4bsd
	!<sys-freebsd/freebsd-sources-9.2_beta1"
DEPEND="build-kernel? (
		dtrace? ( >=sys-freebsd/freebsd-cddl-9.2_rc1 )
		>=sys-freebsd/freebsd-usbin-9.1
		=sys-freebsd/freebsd-mk-defs-${RV}*
	)"

RESTRICT="strip binchecks"

S="${WORKDIR}/sys"

KERN_BUILD=GENTOO

PATCHES=( "${FILESDIR}/${PN}-9.0-disable-optimization.patch"
	"${FILESDIR}/${PN}-10.0-gentoo.patch"
	"${FILESDIR}/${PN}-6.0-flex-2.5.31.patch"
	"${FILESDIR}/${PN}-7.1-types.h-fix.patch"
	"${FILESDIR}/${PN}-8.0-subnet-route-pr40133.patch"
	"${FILESDIR}/${PN}-7.1-includes.patch"
	"${FILESDIR}/${PN}-9.0-sysctluint.patch"
	"${FILESDIR}/${PN}-9.2-gentoo-gcc.patch"
	"${FILESDIR}/${PN}-10.1-gcc48.patch" )

pkg_setup() {
	# Add the required source files.
	use zfs && EXTRACTONLY+="cddl/ "

	# WITHOUT_SSP= is required to boot kernel that compiled with newer gcc, bug #477914
	[[ $(tc-getCC) == *gcc* ]] && mymakeopts="${mymakeopts} WITHOUT_SSP="
	use zfs || mymakeopts="${mymakeopts} WITHOUT_CDDL="
}

src_prepare() {
	local conf="${S}/$(tc-arch-kernel)/conf/${KERN_BUILD}"

	# This replaces the gentoover patch, it doesn't need reapply every time.
	sed -i -e 's:^REVISION=.*:REVISION="'${PVR}'":' \
		-e 's:^BRANCH=.*:BRANCH="Gentoo":' \
		-e 's:^VERSION=.*:VERSION="${TYPE} ${BRANCH} ${REVISION}":' \
		"${S}/conf/newvers.sh"

	# __FreeBSD_cc_version comes from FreeBSD's gcc.
	# on 10.0-RELEASE it's 1000001.
	# FYI, can get it from gnu/usr.bin/cc/cc_tools/freebsd-native.h.
	sed -e "s:-D_KERNEL:-D_KERNEL -D__FreeBSD_cc_version=1000001:g" \
		-i "${S}/conf/kern.pre.mk" \
		-i "${S}/conf/kmod.mk" || die "Couldn't set __FreeBSD_cc_version"

	# Remove -Werror
	sed -e "s:-Werror:-Wno-error:g" \
		-i "${S}/conf/kern.pre.mk" \
		-i "${S}/conf/kmod.mk" || die

	# Set the kernel configuration using USE flags.
	cp -f "${FILESDIR}/config-GENTOO" "${conf}" || die
	use debug || echo 'nomakeoptions DEBUG' >> "${conf}"
	use dtrace || echo 'nomakeoptions WITH_CTF' >> "${conf}"

	# Only used with USE=build-kernel, let the kernel build with its own flags, its safer.
	unset LDFLAGS CFLAGS CXXFLAGS ASFLAGS KERNEL
}

src_configure() {
	if use build-kernel ; then
		tc-export CC
		cd "${S}/$(tc-arch-kernel)/conf" || die
		config ${KERN_BUILD} || die
	fi
}

src_compile() {
	if use build-kernel ; then
		if has_version "<sys-freebsd/freebsd-ubin-10.0"; then
			cd "${WORKDIR}"/usr.bin/bmake || die
			CC=${CHOST}-gcc freebsd_src_compile
			export BMAKE="${WORKDIR}/usr.bin/bmake/make"
		fi
		cd "${S}/$(tc-arch-kernel)/compile/${KERN_BUILD}" || die
		freebsd_src_compile depend
		freebsd_src_compile
	else
		einfo "Nothing to compile.."
	fi
}

src_install() {
	if use build-kernel ; then
		cd "${S}/$(tc-arch-kernel)/compile/${KERN_BUILD}" || die
		freebsd_src_install
		rm -rf "${S}/$(tc-arch-kernel)/compile/${KERN_BUILD}"
		cd "${S}"
	fi

	insinto "/usr/src/sys"
	doins -r "${S}/".
	if use zfs ; then
		insinto "/usr/src/cddl"
		doins -r "${WORKDIR}/cddl/".
	fi
}

pkg_preinst() {
	if [[ -L "${ROOT}/usr/src/sys" ]]; then
		einfo "/usr/src/sys is a symlink, removing it..."
		rm -f "${ROOT}/usr/src/sys"
	fi

	if use sparc-fbsd ; then
		ewarn "WARNING: kldload currently causes kernel panics"
		ewarn "on sparc64. This is probably a gcc-4.1 issue, but"
		ewarn "we need gcc-4.1 to compile the kernel correctly :/"
		ewarn "Please compile all modules you need into the kernel"
	fi

	ewarn "If you want manual compile (not recommended), please don't forget the following step."
	if ! use sparc-fbsd ; then
		ewarn "export CC=clang"
		ewarn "export CXX=clang++"
	fi
	if ! use zfs ; then
		ewarn "export WITHOUT_CDDL="
		ewarn "Note, Please set USE=zfs if you want to enable modules of CDDL license."
	fi
	if ! use dtrace && ! has_version '>=sys-freebsd/freebsd-cddl-9.2_beta1' ; then
		ewarn "GENERIC config require sys-freebsd/freebsd-cddl. Please emerge it."
	fi
}
