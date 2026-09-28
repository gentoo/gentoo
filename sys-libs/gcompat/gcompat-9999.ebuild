# Copyright 2018-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal flag-o-matic git-r3

DESCRIPTION="The GNU C Library compatibility layer for musl"
HOMEPAGE="https://git.adelielinux.org/adelie/gcompat"
EGIT_REPO_URI="https://git.adelielinux.org/adelie/gcompat.git"
LICENSE="UoI-NCSA"
SLOT="0"
IUSE="libucontext obstack"

DEPEND="
	libucontext? ( sys-libs/libucontext )
	obstack? ( sys-libs/obstack-standalone )
"
RDEPEND="${DEPEND}"

get_loader_name() {
	# based on Adélie APKBUILD
	case "$ABI" in
		x86) echo "ld-linux.so.2" ;;
		amd64) echo "ld-linux-x86-64.so.2" ;;
		arm64) echo "ld-linux-aarch64.so.1" ;;
		arm*) echo "ld-linux-armhf.so.3" ;;
		mips | powerpc | s390) echo "ld.so.1" ;;
	esac
}

get_linker_path() {
	local arch=$(ldd 2>&1 | sed -n '1s/^musl libc (\(.*\))$/\1/p')
	echo "/lib/ld-musl-${arch}.so.1"
}

src_compile() {
	filter-flags "-Wl,--as-needed"

	emake \
		LINKER_PATH="$(get_linker_path)" \
		LOADER_NAME="$(get_loader_name)" \
		WITH_OBSTACK="$(usex obstack 'obstack-standalone' 'no')" \
		$(usex libucontext WITH_LIBUCONTEXT=yes '')
}

src_install() {
	emake \
		LINKER_PATH="$(get_linker_path)" \
		LOADER_NAME="$(get_loader_name)" \
		WITH_OBSTACK="$(usex obstack 'obstack-standalone' 'no')" \
		$(usex libucontext WITH_LIBUCONTEXT=yes '') \
		DESTDIR="${D}" \
		install
}
