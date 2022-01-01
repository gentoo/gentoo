# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )

inherit meson multilib-minimal flag-o-matic udev python-any-r1

DESCRIPTION="An interface for filesystems implemented in userspace"
HOMEPAGE="https://github.com/libfuse/libfuse"
SRC_URI="https://github.com/libfuse/libfuse/releases/download/${P}/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="3"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"
IUSE="+suid test"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/pytest[${PYTHON_USEDEP}]')
	)"
RDEPEND=">=sys-fs/fuse-common-3.3.0-r1"

DOCS=( AUTHORS ChangeLog.rst README.md doc/README.NFS doc/kernel.txt )

python_check_deps() {
	has_version -b "dev-python/pytest[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python_setup
}

src_prepare() {
	default

	# lto not supported yet -- https://github.com/libfuse/libfuse/issues/198
	filter-flags '-flto*'
}

multilib_src_configure() {
	local emesonargs=(
		-Dexamples=$(usex test true false)
		-Duseroot=false
		-Dudevrulesdir="${EPREFIX}$(get_udevdir)/rules.d"
	)
	meson_src_configure
}

multilib_src_compile() {
	eninja
}

src_test() {
	if [[ ${EUID} != 0 ]]; then
		ewarn "Running as non-root user, skipping tests"
	elif has sandbox ${FEATURES}; then
		ewarn "Sandbox enabled, skipping tests"
	else
		multilib-minimal_src_test
	fi
}

multilib_src_test() {
	${EPYTHON} -m pytest test || die
}

multilib_src_install() {
	DESTDIR="${D}" eninja install
}

multilib_src_install_all() {
	einstalldocs

	# installed via fuse-common
	rm -r "${ED}"/{etc,$(get_udevdir)} || die

	# useroot=false prevents the build system from doing this.
	use suid && fperms u+s /usr/bin/fusermount3

	# manually install man pages to respect compression
	rm -r "${ED}"/usr/share/man || die
	doman doc/{fusermount3.1,mount.fuse3.8}
}
