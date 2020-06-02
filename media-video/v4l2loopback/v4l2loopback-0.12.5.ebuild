# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod toolchain-funcs

case ${PV} in
9999)
	inherit git-r3
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/umlaeute/v4l2loopback.git"
	;;
*)
	inherit vcs-snapshot
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/umlaeute/v4l2loopback/tarball/v${PV} -> ${P}.tar.gz"
	;;
esac

DESCRIPTION="v4l2 loopback device which output is it's own input"
HOMEPAGE="https://github.com/umlaeute/v4l2loopback"

LICENSE="GPL-2"
SLOT="0"
IUSE="examples"

CONFIG_CHECK="VIDEO_DEV"
MODULE_NAMES="v4l2loopback(video:)"
BUILD_TARGETS="all"

pkg_setup() {
	linux-mod_pkg_setup
	export KERNELRELEASE=${KV_FULL}
}

src_prepare() {
	default
	sed -i -e 's/gcc /$(CC) /' examples/Makefile || die
}

src_compile() {
	linux-mod_src_compile
	if use examples; then
		emake CC=$(tc-getCC) -C examples
	fi
}

src_install() {
	linux-mod_src_install
	dosbin utils/v4l2loopback-ctl
	dodoc doc/kernel_debugging.txt
	dodoc doc/docs.txt
	if use examples; then
		dosbin examples/yuv4mpeg_to_v4l2
		docinto examples
		dodoc examples/{*.sh,*.c,Makefile}
	fi
}
