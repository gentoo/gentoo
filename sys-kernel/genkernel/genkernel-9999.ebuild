# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# genkernel-9999        -> latest Git branch "master"
# genkernel-VERSION     -> normal genkernel release

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

inherit bash-completion-r1 python-single-r1

# Whenever you bump a GKPKG, check if you have to move
# or add new patches!
VERSION_BCACHE_TOOLS="1.0.8_p20141204"
VERSION_BOOST="1.79.0"
VERSION_BTRFS_PROGS="6.3.2"
VERSION_BUSYBOX="1.36.1"
VERSION_COREUTILS="9.3"
VERSION_CRYPTSETUP="2.6.1"
VERSION_DMRAID="1.0.0.rc16-3"
VERSION_DROPBEAR="2022.83"
VERSION_EUDEV="3.2.10"
VERSION_EXPAT="2.5.0"
VERSION_E2FSPROGS="1.46.4"
VERSION_FUSE="2.9.9"
VERSION_GPG="1.4.23"
VERSION_HWIDS="20210613"
VERSION_ISCSI="2.1.8"
VERSION_JSON_C="0.13.1"
VERSION_KMOD="30"
VERSION_LIBAIO="0.3.113"
VERSION_LIBGCRYPT="1.9.4"
VERSION_LIBGPGERROR="1.43"
VERSION_LIBXCRYPT="4.4.36"
VERSION_LVM="2.02.188"
VERSION_LZO="2.10"
VERSION_MDADM="4.1"
VERSION_POPT="1.18"
VERSION_STRACE="6.4"
VERSION_THIN_PROVISIONING_TOOLS="0.9.0"
VERSION_UNIONFS_FUSE="2.0"
VERSION_USERSPACE_RCU="0.14.0"
VERSION_UTIL_LINUX="2.38.1"
VERSION_XFSPROGS="6.3.0"
VERSION_XZ="5.4.3"
VERSION_ZLIB="1.2.13"
VERSION_ZSTD="1.5.5"
VERSION_KEYUTILS="1.6.3"

COMMON_URI="
	https://www.busybox.net/downloads/busybox-${VERSION_BUSYBOX}.tar.bz2
	https://boostorg.jfrog.io/artifactory/main/release/${VERSION_BOOST}/source/boost_${VERSION_BOOST//./_}.tar.bz2
	mirror://gnu/coreutils/coreutils-${VERSION_COREUTILS}.tar.xz
	https://dev.gentoo.org/~blueness/eudev/eudev-${VERSION_EUDEV}.tar.gz
	https://github.com/libexpat/libexpat/releases/download/R_${VERSION_EXPAT//\./_}/expat-${VERSION_EXPAT}.tar.xz
	https://github.com/libfuse/libfuse/releases/download/fuse-${VERSION_FUSE}/fuse-${VERSION_FUSE}.tar.gz
	https://github.com/gentoo/hwids/archive/hwids-${VERSION_HWIDS}.tar.gz
	https://s3.amazonaws.com/json-c_releases/releases/json-c-${VERSION_JSON_C}.tar.gz
	https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-${VERSION_KMOD}.tar.xz
	https://github.com/besser82/libxcrypt/releases/download/v${VERSION_LIBXCRYPT}/libxcrypt-${VERSION_LIBXCRYPT}.tar.xz
	https://releases.pagure.org/libaio/libaio-${VERSION_LIBAIO}.tar.gz
	https://www.oberhumer.com/opensource/lzo/download/lzo-${VERSION_LZO}.tar.gz
	https://lttng.org/files/urcu/userspace-rcu-${VERSION_USERSPACE_RCU}.tar.bz2
	https://www.kernel.org/pub/linux/utils/util-linux/v${VERSION_UTIL_LINUX:0:4}/util-linux-${VERSION_UTIL_LINUX}.tar.xz
	https://tukaani.org/xz/xz-${VERSION_XZ}.tar.gz
	https://zlib.net/zlib-${VERSION_ZLIB}.tar.gz
	https://github.com/facebook/zstd/archive/v${VERSION_ZSTD}.tar.gz -> zstd-${VERSION_ZSTD}.tar.gz
	bcache? ( https://github.com/g2p/bcache-tools/archive/399021549984ad27bf4a13ae85e458833fe003d7.tar.gz -> bcache-tools-${VERSION_BCACHE_TOOLS}.tar.gz )
	btrfs? ( https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v${VERSION_BTRFS_PROGS}.tar.xz )
	e2fsprogs? ( https://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v${VERSION_E2FSPROGS}/e2fsprogs-${VERSION_E2FSPROGS}.tar.xz )
	xfsprogs? ( https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-${VERSION_XFSPROGS}.tar.xz )
	unionfs? ( https://github.com/rpodgorny/unionfs-fuse/archive/v${VERSION_UNIONFS_FUSE}.tar.gz -> unionfs-fuse-${VERSION_UNIONFS_FUSE}.tar.gz )
	iscsi? ( https://github.com/open-iscsi/open-iscsi/archive/${VERSION_ISCSI}.tar.gz -> open-iscsi-${VERSION_ISCSI}.tar.gz )
	luks? ( https://www.kernel.org/pub/linux/utils/cryptsetup/v$(ver_cut 1-2 ${VERSION_CRYPTSETUP})/cryptsetup-${VERSION_CRYPTSETUP}.tar.xz )
	luks? ( mirror://gnupg/gnupg/gnupg-${VERSION_GPG}.tar.bz2 )
	luks? ( mirror://gnupg/libgcrypt/libgcrypt-${VERSION_LIBGCRYPT}.tar.bz2 )
	luks? ( mirror://gnupg/libgpg-error/libgpg-error-${VERSION_LIBGPGERROR}.tar.bz2 )
	luks? ( http://ftp.rpm.org/popt/releases/popt-1.x/popt-${VERSION_POPT}.tar.gz )
	luks? ( https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git/snapshot/keyutils-${VERSION_KEYUTILS}.tar.gz )
	dmraid? ( https://people.redhat.com/~heinzm/sw/dmraid/src/dmraid-${VERSION_DMRAID}.tar.bz2 )
	lvm? ( https://mirrors.kernel.org/sourceware/lvm2/LVM2.${VERSION_LVM}.tgz )
	lvm? ( https://github.com/jthornber/thin-provisioning-tools/archive/v${VERSION_THIN_PROVISIONING_TOOLS}.tar.gz -> thin-provisioning-tools-${VERSION_THIN_PROVISIONING_TOOLS}.tar.gz )
	mdadm? ( https://www.kernel.org/pub/linux/utils/raid/mdadm/mdadm-${VERSION_MDADM}.tar.xz )
	ssh? ( https://matt.ucc.asn.au/dropbear/releases/dropbear-${VERSION_DROPBEAR}.tar.bz2 )
	strace? ( https://github.com/strace/strace/releases/download/v${VERSION_STRACE}/strace-${VERSION_STRACE}.tar.xz )
"

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/${PN}.git"
		inherit git-r3
	S="${WORKDIR}/${P}"
	SRC_URI="${COMMON_URI}"
else
	SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}.tar.xz
		${COMMON_URI}"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

DESCRIPTION="Gentoo automatic kernel building scripts"
HOMEPAGE="https://wiki.gentoo.org/wiki/Genkernel https://gitweb.gentoo.org/proj/genkernel.git/"

LICENSE="GPL-2"
SLOT="0"
RESTRICT=""
IUSE="ibm +firmware +doc btrfs plymouth b2sum bcache dmraid e2fsprogs iscsi luks lvm mdadm multipath ssh strace unionfs xfsprogs zfs"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Note:
# We need sys-devel/* deps like autoconf or automake at _runtime_
# because genkernel will usually build things like LVM2, cryptsetup,
# mdadm... during initramfs generation which will require these
# things.
DEPEND=""
RDEPEND="${PYTHON_DEPS}
	app-alternatives/cpio
	>=app-misc/pax-utils-1.2.2
	app-portage/elt-patches
	app-portage/portage-utils
	dev-util/gperf
	sys-apps/sandbox
	dev-build/autoconf
	dev-build/autoconf-archive
	dev-build/automake
	app-alternatives/bc
	app-alternatives/yacc
	app-alternatives/lex
	dev-build/libtool
	virtual/pkgconfig
	elibc_glibc? ( sys-libs/glibc[static-libs(+)] )
	firmware? ( sys-kernel/linux-firmware )
	plymouth? ( sys-boot/plymouth )
	doc? ( app-text/asciidoc )"

PATCHES=(
)

src_unpack() {
	if [[ ${PV} == 9999* ]]; then
		git-r3_src_unpack
	else
		local gk_src_file
		for gk_src_file in ${A} ; do
			if [[ ${gk_src_file} == genkernel-* ]] ; then
				unpack "${gk_src_file}"
			fi
		done
	fi
}

src_prepare() {
	default

	if [[ ${PV} == 9999* ]] ; then
		einfo "Updating version tag"
		GK_V="$(git describe --tags | sed 's:^v::')-git"
		sed "/^GK_V/s,=.*,='${GK_V}',g" -i "${S}"/genkernel
		einfo "Producing ChangeLog from Git history..."
		pushd "${S}/.git" >/dev/null || die
		git log > "${S}"/ChangeLog || die
		popd >/dev/null || die
	fi

	# Update software.sh
	export VERSION_BCACHE_TOOLS VERSION_BOOST VERSION_BTRFS_PROGS VERSION_BUSYBOX VERSION_COREUTILS
	export VERSION_CRYPTSETUP VERSION_DMRAID VERSION_DROPBEAR VERSION_EUDEV VERSION_EXPAT VERSION_E2FSPROGS
	export VERSION_FUSE VERSION_GPG VERSION_HWIDS VERSION_ISCSI VERSION_JSON_C VERSION_KMOD VERSION_LIBAIO
	export VERSION_LIBGCRYPT VERSION_LIBGPGERROR VERSION_LIBXCRYPT VERSION_LVM VERSION_LZO VERSION_MDADM
	export VERSION_POPT VERSION_STRACE VERSION_THIN_PROVISIONING_TOOLS VERSION_UNIONFS_FUSE VERSION_USERSPACE_RCU
	export VERSION_UTIL_LINUX VERSION_XFSPROGS VERSION_XZ VERSION_ZLIB VERSION_ZSTD VERSION_KEYUTILS

	GK_FEATURES=""  # prepare genkernel feature list

	if use b2sum ; then GK_FEATURES="${GK_FEATURES}b2sum " ; fi
	if use bcache ; then GK_FEATURES="${GK_FEATURES}bcache " ; fi
	if use btrfs ; then GK_FEATURES="${GK_FEATURES}btrfs " ; fi
	if use dmraid ; then GK_FEATURES="${GK_FEATURES}dmraid " ; fi
	if use e2fsprogs ; then GK_FEATURES="${GK_FEATURES}e2fsprogs " ; fi
	if use iscsi ; then GK_FEATURES="${GK_FEATURES}iscsi " ; fi
	if use luks ; then GK_FEATURES="${GK_FEATURES}luks " ; fi
	if use lvm ; then GK_FEATURES="${GK_FEATURES}lvm " ; fi
	if use mdadm ; then GK_FEATURES="${GK_FEATURES}mdadm " ; fi
	if use multipath ; then GK_FEATURES="${GK_FEATURES}multipath " ; fi
	if use plymouth ; then GK_FEATURES="${GK_FEATURES}plymouth " ; fi
	# if use splash ; then GK_FEATURES="${GK_FEATURES}splash " ; fi
	if use ssh ; then GK_FEATURES="${GK_FEATURES}ssh " ; fi
	if use strace ; then GK_FEATURES="${GK_FEATURES}strace " ; fi
	if use unionfs ; then GK_FEATURES="${GK_FEATURES}unionfs " ; fi
	if use xfsprogs ; then GK_FEATURES="${GK_FEATURES}xfsprogs " ; fi
	if use zfs ; then GK_FEATURES="${GK_FEATURES}zfs " ; fi

	export GK_FEATURES
}

src_compile() {
	emake PREFIX=/usr
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install

	python_fix_shebang "${ED}"/usr/share/genkernel/path_expander.py

	newbashcomp "${FILESDIR}"/genkernel-4.bash "${PN}"
	insinto /etc
	doins "${FILESDIR}"/initramfs.mounts

	pushd "${DISTDIR}" &>/dev/null || die
	insinto /usr/share/genkernel/distfiles
	doins ${A/${P}.tar.xz/}
	popd &>/dev/null || die
}

pkg_postinst() {
	# Wiki is out of date
	#echo
	#elog 'Documentation is available in the genkernel manual page'
	#elog 'as well as the following URL:'
	#echo
	#elog 'https://wiki.gentoo.org/wiki/Genkernel'
	#echo

	local replacing_version
	for replacing_version in ${REPLACING_VERSIONS} ; do
		if ver_test "${replacing_version}" -lt 4 ; then
			# This is an upgrade which requires user review

			ewarn ""
			ewarn "Genkernel v4.x is a new major release which touches"
			ewarn "nearly everything. Be careful, read updated manpage"
			ewarn "and pay special attention to program output regarding"
			ewarn "changed kernel command-line parameters!"

			# Show this elog only once
			break
		fi
	done

	if [[ $(find /boot -name 'kernel-genkernel-*' 2>/dev/null | wc -l) -gt 0 ]] ; then
		ewarn ''
		ewarn 'Default kernel filename was changed from "kernel-genkernel-<ARCH>-<KV>"'
		ewarn 'to "vmlinuz-<KV>". Please be aware that due to lexical ordering the'
		ewarn '*default* boot entry in your boot manager could still point to last kernel'
		ewarn 'built with genkernel before that name change, resulting in booting old'
		ewarn 'kernel when not paying attention on boot.'
	fi

	# Show special warning for users depending on remote unlock capabilities
	local gk_config="${EROOT}/etc/genkernel.conf"
	if [[ -f "${gk_config}" ]] ; then
		if grep -q -E "^SSH=[\"\']?yes" "${gk_config}" 2>/dev/null ; then
			if ! grep -q dosshd /proc/cmdline 2>/dev/null ; then
				ewarn ""
				ewarn "IMPORTANT: SSH is currently enabled in your genkernel config"
				ewarn "file (${gk_config}). However, 'dosshd' is missing from current"
				ewarn "kernel command-line. You MUST add 'dosshd' to keep sshd enabled"
				ewarn "in genkernel v4+ initramfs!"
			fi
		fi

		if grep -q -E "^CMD_CALLBACK=.*emerge.*@module-rebuild" "${gk_config}" 2>/dev/null ; then
			elog ""
			elog "Please remove 'emerge @module-rebuild' from genkernel config"
			elog "file (${gk_config}) and make use of new MODULEREBUILD option"
			elog "instead."
		fi
	fi

	local n_root_args=$(grep -o -- '\<root=' /proc/cmdline 2>/dev/null | wc -l)
	if [[ ${n_root_args} -gt 1 ]] ; then
		ewarn "WARNING: Multiple root arguments (root=) on kernel command-line detected!"
		ewarn "If you are appending non-persistent device names to kernel command-line,"
		ewarn "next reboot could fail in case running system and initramfs do not agree"
		ewarn "on detected root device name!"
	fi

	if [[ -d /run ]] ; then
		local permission_run_expected="drwxr-xr-x"
		local permission_run=$(stat -c "%A" /run)
		if [[ "${permission_run}" != "${permission_run_expected}" ]] ; then
			ewarn "Found the following problematic permissions:"
			ewarn ""
			ewarn "    ${permission_run} /run"
			ewarn ""
			ewarn "Expected:"
			ewarn ""
			ewarn "    ${permission_run_expected} /run"
			ewarn ""
			ewarn "This is known to be causing problems for any UDEV-enabled service."
		fi
	fi
}
