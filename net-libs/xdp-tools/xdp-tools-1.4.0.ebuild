# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="The libxdp library and various tools for use with XDP"
HOMEPAGE="https://github.com/xdp-project/xdp-tools"
SRC_URI="https://github.com/xdp-project/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="+tools"

DEPEND="
	dev-libs/libbpf:=
	dev-util/bpftool
	net-libs/libpcap
	sys-libs/zlib
	virtual/libelf
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-apps/grep[pcre]
	>=sys-devel/clang-11.0.0
"

# Not prebuilt -- we build them -- but they're not ordinary ELF objects either.
QA_PREBUILT="usr/lib/bpf/*.o"

MAKEOPTS+=" V=1"

PATCHES=(
	"${FILESDIR}"/1.3.1-no-Werror.patch
	"${FILESDIR}"/${PV}-toolchain.patch
)

src_configure() {
	export CC="$(tc-getCC)"
	export LD="$(tc-getLD)"
	export PREFIX="${EPREFIX}/usr"
	export LIBDIR="${PREFIX}/$(get_libdir)"
	export BPF_OBJECT_DIR="${PREFIX}/lib/bpf"
	export PRODUCTION=1
	export DYNAMIC_LIBXDP=1
	export FORCE_SYSTEM_LIBBPF=1

	# bug 861587
	filter-lto

	default
}

src_test() { :; }

src_install() {
	default

	# To remove the scripts/testing files that are installed.
	rm -r "${ED}/usr/share/xdp-tools" || die
	# We can't control static archive generation yet.
	rm "${ED}/usr/$(get_libdir)/libxdp.a" || die

	use tools || { rm "${ED}/usr/sbin"/* || die; }

	# These are ELF objects but BPF ones.
	dostrip -x /usr/lib/bpf
}

pkg_postinst() {
	elog
	elog "Many BPF utilities need access to a mounted bpffs virtual file system."
	elog "Either mount it manually like this:"
	elog
	elog "  mount bpffs /sys/fs/bpf -t bpf -o nosuid,nodev,noexec,relatime,mode=700"
	elog
	elog "or add the following line to your /etc/fstab to always mount it at boot time:"
	elog
	elog "  bpffs  /sys/fs/bpf  bpf  nosuid,nodev,noexec,relatime,mode=700  0 0"
	elog
	elog "You can verify that bpffs is mounted with:"
	elog
	elog "  mount | grep /sys/fs/bpf"
	elog
}
