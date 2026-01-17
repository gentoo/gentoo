# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info meson shell-completion toolchain-funcs

DESCRIPTION="Library and tools for managing linux kernel modules"
HOMEPAGE="https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git"

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/utils/kernel/${PN}/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
fi

LICENSE="LGPL-2.1+ tools? ( GPL-2+ )"
SLOT="0"
IUSE="debug doc +lzma pkcs7 +tools +zlib +zstd"

# - >=zlib-1.2.6 required because of bug #427130
# - >=zstd-1.5.2-r1 required for bug #771078
RDEPEND="
	lzma? ( >=app-arch/xz-utils-5.0.4-r1 )
	pkcs7? ( >=dev-libs/openssl-1.1.0:= )
	zlib? ( >=virtual/zlib-1.2.6:= )
	zstd? ( >=app-arch/zstd-1.5.2-r1:= )
"
DEPEND="${RDEPEND}"

# >=dev-build/meson-1.7.0 to avoid building tests in compile phase
# https://github.com/mesonbuild/meson/issues/2518
BDEPEND="
	app-text/scdoc
	>=dev-build/meson-1.7.0
	doc? ( dev-util/gtk-doc )
	lzma? ( virtual/pkgconfig )
	zlib? ( virtual/pkgconfig )
"

PATCHES=(
	"${FILESDIR}/${P}-s390.patch"
)

pkg_setup() {
	:
}

src_configure() {
	# TODO: >=33 enables decompressing without libraries being built in
	# as kmod defers to the kernel. How should the ebuild be adapted?
	local emesonargs=(
		--bindir "${EPREFIX}/bin"
		--sbindir "${EPREFIX}/sbin"
		-Dbuild-tests=true
		-Dbashcompletiondir="$(get_bashcompdir)"
		-Dfishcompletiondir="$(get_fishcompdir)"
		-Dzshcompletiondir="$(get_zshcompdir)"
		$(meson_use debug debug-messages)
		$(meson_use doc docs)
		$(meson_use tools)
		$(meson_feature lzma xz)
		$(meson_feature pkcs7 openssl)
		$(meson_feature zlib)
		$(meson_feature zstd)
	)

	meson_src_configure
}

src_test() {
	if [[ ${LD_PRELOAD} == *libsandbox* ]]; then
		ewarn "Skipping tests: libsandbox in LD_PRELOAD"
		return
	fi
	if ! get_version; then
		ewarn "Skipping tests: could not find kernel directory"
		return
	fi
	local -x ARCH=$(tc-arch-kernel)
	local -x CROSS_COMPILE=${CHOST}-
	local -x KDIR=${KV_OUT_DIR}
	meson_src_test
}

src_install() {
	meson_src_install
	newinitd "${FILESDIR}"/kmod-static-nodes-r1 kmod-static-nodes
}

pkg_postinst() {
	if [[ -L ${EROOT}/etc/runlevels/boot/static-nodes ]]; then
		ewarn "Removing old conflicting static-nodes init script from the boot runlevel"
		rm -f "${EROOT}"/etc/runlevels/boot/static-nodes
	fi

	# Add kmod to the runlevel automatically if this is the first install of this package.
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		if [[ ! -d ${EROOT}/etc/runlevels/sysinit ]]; then
			mkdir -p "${EROOT}"/etc/runlevels/sysinit
		fi
		if [[ -x ${EROOT}/etc/init.d/kmod-static-nodes ]]; then
			ln -s /etc/init.d/kmod-static-nodes "${EROOT}"/etc/runlevels/sysinit/kmod-static-nodes
		fi
	fi

	if [[ -e ${EROOT}/etc/runlevels/sysinit ]]; then
		if ! has_version sys-apps/systemd && [[ ! -e ${EROOT}/etc/runlevels/sysinit/kmod-static-nodes ]]; then
			ewarn
			ewarn "You need to add kmod-static-nodes to the sysinit runlevel for"
			ewarn "kernel modules to have required static nodes!"
			ewarn "Run this command:"
			ewarn "\trc-update add kmod-static-nodes sysinit"
		fi
	fi
}
