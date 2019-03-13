# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools linux-mod multilib toolchain-funcs versionator

MY_PV=$(delete_version_separator '_')
MY_PN="${PN/-kernel}"
MY_P="${MY_PN}-${MY_PV}"
PVER="20170822"

DESCRIPTION="The OpenAFS distributed file system kernel module"
HOMEPAGE="https://www.openafs.org/"
# We always d/l the doc tarball as man pages are not USE=doc material
[[ ${PV} == *_pre* ]] && MY_PRE="candidate/" || MY_PRE=""
SRC_URI="
	https://openafs.org/dl/openafs/${MY_PRE}${MY_PV}/${MY_P}-src.tar.bz2
	https://dev.gentoo.org/~bircoph/afs/${MY_PN}-patches-${PVER}.tar.xz
"

LICENSE="IBM BSD openafs-krb5-a APSL-2"
SLOT="0"
KEYWORDS="amd64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug"

S=${WORKDIR}/${MY_P}

CONFIG_CHECK="~!AFS_FS KEYS"
ERROR_AFS_FS="OpenAFS conflicts with the in-kernel AFS-support. Make sure not to load both at the same time!"
ERROR_KEYS="OpenAFS needs CONFIG_KEYS option enabled"

QA_TEXTRELS_x86_fbsd="/boot/modules/libafs.ko"
QA_TEXTRELS_amd64_fbsd="/boot/modules/libafs.ko"

PATCHES=( "${WORKDIR}/gentoo/patches" )

pkg_pretend() {
	if use kernel_linux && kernel_is ge 4 15 ; then
		ewarn "Gentoo supports kernels which are supported by OpenAFS"
		ewarn "which are limited to the kernel versions: < 4.15"
		ewarn ""
		ewarn "You are free to utilize epatch_user to provide whatever"
		ewarn "support you feel is appropriate, but will not receive"
		ewarn "support as a result of those changes."
		ewarn ""
		ewarn "Please do not file a bug report about this."
	fi
}

pkg_setup() {
	if use kernel_linux; then
		linux-mod_pkg_setup
	fi
}

src_prepare() {
	default

	# packaging is f-ed up, so we can't run eautoreconf
	# run autotools commands based on what is listed in regen.sh
	eaclocal -I src/cf
	eautoconf
	eautoconf -o configure-libafs configure-libafs.ac
	eautoheader
	einfo "Deleting autom4te.cache directory"
	rm -rf autom4te.cache
}

src_configure() {
	local myconf=""
	# OpenAFS 1.6.11 has a bug with kernels 3.17-3.17.2 that requires a config option
	if use kernel_linux && kernel_is -ge 3 17 && kernel_is -le 3 17 2; then
		myconf="--enable-linux-d_splice_alias-extra-iput"
	fi

	local ARCH="$(tc-arch-kernel)"
	local MY_ARCH="$(tc-arch)"
	local BSD_BUILD_DIR="/usr/src/sys/${MY_ARCH}/compile/GENERIC"

	if use kernel_linux; then
		myconf+=( --with-linux-kernel-headers="${KV_DIR}" \
			--with-linux-kernel-build="${KV_OUT_DIR}"
		)
	elif use kernel_FreeBSD; then
		myconf+=( --with-bsd-kernel-build="${BSD_BUILD_DIR}" )
	fi
	econf \
		$(use_enable debug debug-kernel) \
		"${myconf[@]}"
}

src_compile() {
	ARCH="$(tc-arch-kernel)" AR="$(tc-getAR)" emake V=1 -j1 only_libafs
}

src_install() {
	if use kernel_linux; then
		local srcdir=$(expr "${S}"/src/libafs/MODLOAD-*)
		[[ -f ${srcdir}/libafs.${KV_OBJ} ]] || die "Couldn't find compiled kernel module"

		MODULE_NAMES="libafs(fs/openafs:${srcdir})"

		linux-mod_src_install
	elif use kernel_FreeBSD; then
		insinto /boot/modules
		doins "${S}"/src/libafs/MODLOAD/libafs.ko
	fi
}

pkg_postinst() {
	# Update linker.hints file
	use kernel_FreeBSD && /usr/sbin/kldxref "${EPREFIX}/boot/modules"
	use kernel_linux && linux-mod_pkg_postinst

	if use kernel_linux; then
		local v
		for v in ${REPLACING_VERSIONS}; do
			if ! version_is_at_least 1.6.18.2 ${v}; then
				ewarn "As of OpenAFS 1.6.18.2, Gentoo's packaging no longer requires"
				ewarn "that CONFIG_DEBUG_RODATA be turned off in one's kernel config."
				ewarn "If you only turned this option off for OpenAFS, please re-enable"
				ewarn "it, as keeping it turned off is a security risk."
				break
			fi
		done
	fi
}

pkg_postrm() {
	# Update linker.hints file
	use kernel_FreeBSD && /usr/sbin/kldxref "${EPREFIX}/boot/modules"
	use kernel_linux && linux-mod_pkg_postrm
}
