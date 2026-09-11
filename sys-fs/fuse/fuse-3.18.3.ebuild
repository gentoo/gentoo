# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
inherit flag-o-matic meson-multilib toolchain-funcs udev python-any-r1

DESCRIPTION="An interface for filesystems implemented in userspace"
HOMEPAGE="https://github.com/libfuse/libfuse"
SRC_URI="https://github.com/libfuse/libfuse/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="3/4"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="io-uring +suid systemtap test"
RESTRICT="!test? ( test )"

DEPEND="
	io-uring? (
		sys-libs/liburing:=[${MULTILIB_USEDEP}]
		sys-process/numactl
	)
"
RDEPEND="
	${DEPEND}
	>=sys-fs/fuse-common-3.3.0-r1
"
BDEPEND="
	virtual/pkgconfig
	test? (
		${PYTHON_DEPS}
	)
"

DOCS=( AUTHORS ChangeLog.rst README.md doc/README.NFS doc/kernel.txt )

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

multilib_src_configure() {
	# bug #853058
	tc-is-clang && filter-lto

	local emesonargs=(
		$(meson_use test examples)
		$(meson_use test tests)
		$(meson_use systemtap enable-usdt)
		$(meson_use io-uring enable-io-uring)
		-Duseroot=false
		-Dinitscriptdir=
		-Dudevrulesdir="${EPREFIX}$(get_udevdir)/rules.d"
	)
	meson_src_configure
}

src_test() {
	# Need short unix socket paths
	local -x TMPDIR=/tmp
	# mount/mountpoint-validation fails
	local -x SANDBOX_ON=0
	# Don't try to use systemd-run
	local -x FUSE_TESTS_UNDER_SCOPE=1

	multilib-minimal_src_test
}

multilib_src_install_all() {
	# Installed via fuse-common
	rm -r "${ED}"{/etc,$(get_udevdir)} || die

	# useroot=false prevents the build system from doing this.
	use suid && fperms u+s /usr/bin/fusermount3

	# manually install man pages to respect compression
	rm -r "${ED}"/usr/share/man || die
	doman doc/{fusermount3.1,mount.fuse3.8}
}
