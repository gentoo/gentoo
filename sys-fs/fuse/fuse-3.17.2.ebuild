# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit flag-o-matic meson-multilib udev python-any-r1

DESCRIPTION="An interface for filesystems implemented in userspace"
HOMEPAGE="https://github.com/libfuse/libfuse"
SRC_URI="https://github.com/libfuse/libfuse/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="3/4"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="+suid test"
RESTRICT="test"
PROPERTIES="test_privileged"

BDEPEND="
	virtual/pkgconfig
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/pytest[${PYTHON_USEDEP}]')
		$(python_gen_any_dep 'dev-python/looseversion[${PYTHON_USEDEP}]')
	)
"
RDEPEND=">=sys-fs/fuse-common-3.3.0-r1"

DOCS=( AUTHORS ChangeLog.rst README.md doc/README.NFS doc/kernel.txt )

python_check_deps() {
	python_has_version "dev-python/pytest[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/looseversion[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

multilib_src_configure() {
	# bug #853058
	filter-lto

	local emesonargs=(
		$(meson_use test examples)
		$(meson_use test tests)
		-Duseroot=false
		-Dinitscriptdir=
		-Dudevrulesdir="${EPREFIX}$(get_udevdir)/rules.d"
	)
	meson_src_configure
}

src_test() {
	# For tests to pass:
	# sandbox must be disabled.
	# Write access to /dev/cuse* and /dev/fuse is required.
	# root must be a member of the portage group; CAP_DAC_OVERRIDE is dropped.
	# TMPDIR must be short for unix socket paths.
	local -x TMPDIR=/tmp
	multilib-minimal_src_test
}

multilib_src_test() {
	epytest
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
