# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools libtool bash-completion-r1

DESCRIPTION="Library and tools for managing linux kernel modules"
HOMEPAGE="https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git"

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/utils/kernel/${PN}/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

LICENSE="LGPL-2"
SLOT="0"
IUSE="debug doc +lzma pkcs7 static-libs +tools +zlib +zstd"

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
	doc? (
		dev-util/gtk-doc
		dev-build/gtk-doc-am
	)
	lzma? ( virtual/pkgconfig )
	zlib? ( virtual/pkgconfig )
"
if [[ ${PV} == 9999* ]]; then
	BDEPEND+=" app-text/scdoc"
fi

src_prepare() {
	default

	if [[ ! -e configure ]] || use doc ; then
		if use doc; then
			cp "${BROOT}"/usr/share/aclocal/gtk-doc.m4 m4 || die
			gtkdocize --copy --docdir libkmod/docs || die
		else
			touch libkmod/docs/gtk-doc.make
		fi
		eautoreconf
	else
		elibtoolize
	fi

	# Restore possibility of running --enable-static, bug #472608
	sed -i \
		-e '/--enable-static is not supported by kmod/s:as_fn_error:echo:' \
		configure || die
}

src_configure() {
	# TODO: >=33 enables decompressing without libraries being built in
	# as kmod defers to the kernel. How should the ebuild be adapted?
	local myeconfargs=(
		--bindir="${EPREFIX}/bin"
		--sbindir="${EPREFIX}/sbin"
		--enable-shared
		--with-bashcompletiondir="$(get_bashcompdir)"
		$(use_enable debug)
		$(usev doc '--enable-gtk-doc')
		$(use_enable static-libs static)
		$(use_enable tools)
		$(use_with lzma xz)
		$(use_with pkcs7 openssl)
		$(use_with zlib)
		$(use_with zstd)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -type f -name "*.la" -delete || die

	if use tools; then
		local cmd
		for cmd in depmod insmod modprobe rmmod; do
			rm "${ED}"/bin/${cmd} || die
			dosym ../bin/kmod /sbin/${cmd}
		done
	fi

	cat <<-EOF > "${T}"/usb-load-ehci-first.conf
	softdep uhci_hcd pre: ehci_hcd
	softdep ohci_hcd pre: ehci_hcd
	EOF

	insinto /lib/modprobe.d
	# bug #260139
	doins "${T}"/usb-load-ehci-first.conf

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
