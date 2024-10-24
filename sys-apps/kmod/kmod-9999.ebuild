# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson shell-completion

DESCRIPTION="Library and tools for managing linux kernel modules"
HOMEPAGE="https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git"

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/utils/kernel/${PN}/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

LICENSE="LGPL-2"
SLOT="0"
IUSE="debug doc +lzma pkcs7 +tools +zlib +zstd"

# Upstream does not support running the test suite with custom configure flags.
# I was also told that the test suite is intended for kmod developers.
# So we have to restrict it.
# See bug #408915.
#RESTRICT="test"

# - >=zlib-1.2.6 required because of bug #427130
# - Block systemd below 217 for -static-nodes-indicate-that-creation-of-static-nodes-.patch
# - >=zstd-1.5.2-r1 required for bug #771078
RDEPEND="
	!sys-apps/module-init-tools
	!sys-apps/modutils
	!<sys-apps/openrc-0.13.8
	!<sys-apps/systemd-216-r3
	lzma? ( >=app-arch/xz-utils-5.0.4-r1 )
	pkcs7? ( >=dev-libs/openssl-1.1.0:= )
	zlib? ( >=sys-libs/zlib-1.2.6 )
	zstd? ( >=app-arch/zstd-1.5.2-r1:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/scdoc
	doc? ( dev-util/gtk-doc )
	lzma? ( virtual/pkgconfig )
	zlib? ( virtual/pkgconfig )
"
src_configure() {
	# TODO: >=33 enables decompressing without libraries being built in
	# as kmod defers to the kernel. How should the ebuild be adapted?
	local emesonargs=(
		--bindir "${EPREFIX}/bin"
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

src_install() {
	meson_src_install

	if use tools; then
		local cmd
		for cmd in depmod insmod modprobe rmmod; do
			rm "${ED}"/bin/${cmd} || die
			dosym ../bin/kmod /sbin/${cmd}
		done
	fi

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
