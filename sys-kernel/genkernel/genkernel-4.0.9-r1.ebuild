# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# genkernel-9999        -> latest Git branch "master"
# genkernel-VERSION     -> normal genkernel release

EAPI="7"

inherit bash-completion-r1

# Whenever you bump a GKPKG, check if you have to move
# or add new patches!
VERSION_BOOST="1.73.0"
VERSION_BTRFS_PROGS="5.6.1"
VERSION_BUSYBOX="1.31.1"
VERSION_COREUTILS="8.32"
VERSION_CRYPTSETUP="2.3.3"
VERSION_DMRAID="1.0.0.rc16-3"
VERSION_DROPBEAR="2020.80"
VERSION_EXPAT="2.2.9"
VERSION_E2FSPROGS="1.45.6"
VERSION_FUSE="2.9.9"
VERSION_GPG="1.4.23"
VERSION_ISCSI="2.0.878"
VERSION_JSON_C="0.13.1"
VERSION_KMOD="27"
VERSION_LIBAIO="0.3.112"
VERSION_LIBGCRYPT="1.8.5"
VERSION_LIBGPGERROR="1.38"
VERSION_LVM="2.02.187"
VERSION_LZO="2.10"
VERSION_MDADM="4.1"
VERSION_POPT="1.16"
VERSION_STRACE="5.7"
VERSION_THIN_PROVISIONING_TOOLS="0.8.5"
VERSION_UNIONFS_FUSE="2.0"
VERSION_UTIL_LINUX="2.35.2"
VERSION_XFSPROGS="5.6.0"
VERSION_ZLIB="1.2.11"
VERSION_ZSTD="1.4.4"

COMMON_URI="
	https://dl.bintray.com/boostorg/release/${VERSION_BOOST}/source/boost_${VERSION_BOOST//./_}.tar.bz2
	https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v${VERSION_BTRFS_PROGS}.tar.xz
	https://www.busybox.net/downloads/busybox-${VERSION_BUSYBOX}.tar.bz2
	mirror://gnu/coreutils/coreutils-${VERSION_COREUTILS}.tar.xz
	https://www.kernel.org/pub/linux/utils/cryptsetup/v$(ver_cut 1-2 ${VERSION_CRYPTSETUP})/cryptsetup-${VERSION_CRYPTSETUP}.tar.xz
	https://people.redhat.com/~heinzm/sw/dmraid/src/dmraid-${VERSION_DMRAID}.tar.bz2
	https://dev.gentoo.org/~whissi/dist/dropbear/dropbear-${VERSION_DROPBEAR}.tar.bz2
	https://github.com/libexpat/libexpat/releases/download/R_${VERSION_EXPAT//\./_}/expat-${VERSION_EXPAT}.tar.xz
	https://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v${VERSION_E2FSPROGS}/e2fsprogs-${VERSION_E2FSPROGS}.tar.xz
	https://github.com/libfuse/libfuse/releases/download/fuse-${VERSION_FUSE}/fuse-${VERSION_FUSE}.tar.gz
	mirror://gnupg/gnupg/gnupg-${VERSION_GPG}.tar.bz2
	https://github.com/open-iscsi/open-iscsi/archive/${VERSION_ISCSI}.tar.gz -> open-iscsi-${VERSION_ISCSI}.tar.gz
	https://s3.amazonaws.com/json-c_releases/releases/json-c-${VERSION_JSON_C}.tar.gz
	https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-${VERSION_KMOD}.tar.xz
	https://releases.pagure.org/libaio/libaio-${VERSION_LIBAIO}.tar.gz
	mirror://gnupg/libgcrypt/libgcrypt-${VERSION_LIBGCRYPT}.tar.bz2
	mirror://gnupg/libgpg-error/libgpg-error-${VERSION_LIBGPGERROR}.tar.bz2
	https://mirrors.kernel.org/sourceware/lvm2/LVM2.${VERSION_LVM}.tgz
	https://www.oberhumer.com/opensource/lzo/download/lzo-${VERSION_LZO}.tar.gz
	https://www.kernel.org/pub/linux/utils/raid/mdadm/mdadm-${VERSION_MDADM}.tar.xz
	http://ftp.rpm.org/mirror/popt/popt-${VERSION_POPT}.tar.gz
	https://github.com/strace/strace/releases/download/v${VERSION_STRACE}/strace-${VERSION_STRACE}.tar.xz
	https://github.com/jthornber/thin-provisioning-tools/archive/v${VERSION_THIN_PROVISIONING_TOOLS}.tar.gz -> thin-provisioning-tools-${VERSION_THIN_PROVISIONING_TOOLS}.tar.gz
	https://github.com/rpodgorny/unionfs-fuse/archive/v${VERSION_UNIONFS_FUSE}.tar.gz -> unionfs-fuse-${VERSION_UNIONFS_FUSE}.tar.gz
	https://www.kernel.org/pub/linux/utils/util-linux/v${VERSION_UTIL_LINUX:0:4}/util-linux-${VERSION_UTIL_LINUX}.tar.xz
	https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-${VERSION_XFSPROGS}.tar.xz
	https://zlib.net/zlib-${VERSION_ZLIB}.tar.gz
	https://github.com/facebook/zstd/archive/v${VERSION_ZSTD}.tar.gz -> zstd-${VERSION_ZSTD}.tar.gz
"

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/${PN}.git"
	inherit git-r3
	S="${WORKDIR}/${P}"
	SRC_URI="${COMMON_URI}"
else
	SRC_URI="https://dev.gentoo.org/~whissi/dist/genkernel/${P}.tar.xz
		${COMMON_URI}"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86"
fi

DESCRIPTION="Gentoo automatic kernel building scripts"
HOMEPAGE="https://wiki.gentoo.org/wiki/Genkernel https://gitweb.gentoo.org/proj/genkernel.git/"

LICENSE="GPL-2"
SLOT="0"
RESTRICT=""
IUSE="ibm +firmware"

# Note:
# We need sys-devel/* deps like autoconf or automake at _runtime_
# because genkernel will usually build things like LVM2, cryptsetup,
# mdadm... during initramfs generation which will require these
# things.
DEPEND=""
RDEPEND="${DEPEND}
	app-arch/cpio
	>=app-misc/pax-utils-1.2.2
	app-portage/elt-patches
	sys-apps/sandbox
	sys-devel/autoconf
	sys-devel/autoconf-archive
	sys-devel/automake
	sys-devel/libtool
	virtual/pkgconfig
	firmware? ( sys-kernel/linux-firmware )"

if [[ ${PV} == 9999* ]]; then
	DEPEND="${DEPEND} app-text/asciidoc"
fi

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
	sed -i \
		-e "s:VERSION_BOOST:${VERSION_BOOST}:"\
		-e "s:VERSION_BTRFS_PROGS:${VERSION_BTRFS_PROGS}:"\
		-e "s:VERSION_BUSYBOX:${VERSION_BUSYBOX}:"\
		-e "s:VERSION_COREUTILS:${VERSION_COREUTILS}:"\
		-e "s:VERSION_CRYPTSETUP:${VERSION_CRYPTSETUP}:"\
		-e "s:VERSION_DMRAID:${VERSION_DMRAID}:"\
		-e "s:VERSION_DROPBEAR:${VERSION_DROPBEAR}:"\
		-e "s:VERSION_EUDEV:${VERSION_EUDEV}:"\
		-e "s:VERSION_EXPAT:${VERSION_EXPAT}:"\
		-e "s:VERSION_E2FSPROGS:${VERSION_E2FSPROGS}:"\
		-e "s:VERSION_FUSE:${VERSION_FUSE}:"\
		-e "s:VERSION_GPG:${VERSION_GPG}:"\
		-e "s:VERSION_ISCSI:${VERSION_ISCSI}:"\
		-e "s:VERSION_JSON_C:${VERSION_JSON_C}:"\
		-e "s:VERSION_KMOD:${VERSION_KMOD}:"\
		-e "s:VERSION_LIBAIO:${VERSION_LIBAIO}:"\
		-e "s:VERSION_LIBGCRYPT:${VERSION_LIBGCRYPT}:"\
		-e "s:VERSION_LIBGPGERROR:${VERSION_LIBGPGERROR}:"\
		-e "s:VERSION_LVM:${VERSION_LVM}:"\
		-e "s:VERSION_LZO:${VERSION_LZO}:"\
		-e "s:VERSION_MDADM:${VERSION_MDADM}:"\
		-e "s:VERSION_MULTIPATH_TOOLS:${VERSION_MULTIPATH_TOOLS}:"\
		-e "s:VERSION_POPT:${VERSION_POPT}:"\
		-e "s:VERSION_STRACE:${VERSION_STRACE}:"\
		-e "s:VERSION_THIN_PROVISIONING_TOOLS:${VERSION_THIN_PROVISIONING_TOOLS}:"\
		-e "s:VERSION_UNIONFS_FUSE:${VERSION_UNIONFS_FUSE}:"\
		-e "s:VERSION_USERSPACE_RCU:${VERSION_USERSPACE_RCU}:"\
		-e "s:VERSION_UTIL_LINUX:${VERSION_UTIL_LINUX}:"\
		-e "s:VERSION_XFSPROGS:${VERSION_XFSPROGS}:"\
		-e "s:VERSION_ZLIB:${VERSION_ZLIB}:"\
		-e "s:VERSION_ZSTD:${VERSION_ZSTD}:"\
		"${S}"/defaults/software.sh \
		|| die "Could not adjust versions"
}

src_compile() {
	if [[ ${PV} == 9999* ]] ; then
		emake
	fi
}

src_install() {
	insinto /etc
	doins "${S}"/genkernel.conf

	doman genkernel.8
	dodoc AUTHORS ChangeLog README TODO
	dobin genkernel
	rm -f genkernel genkernel.8 AUTHORS ChangeLog README TODO genkernel.conf

	if use ibm ; then
		cp "${S}"/arch/ppc64/kernel-2.6{-pSeries,} || die
	else
		cp "${S}"/arch/ppc64/kernel-2.6{.g5,} || die
	fi

	insinto /usr/share/genkernel
	doins -r "${S}"/*

	fperms +x /usr/share/genkernel/gen_worker.sh

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
}
