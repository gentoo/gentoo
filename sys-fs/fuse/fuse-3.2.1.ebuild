# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )

inherit meson multilib-minimal flag-o-matic python-single-r1

DESCRIPTION="An interface for filesystems implemented in userspace"
HOMEPAGE="https://github.com/libfuse/libfuse"
SRC_URI="https://github.com/libfuse/libfuse/releases/download/${P}/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="virtual/pkgconfig
	test? (
		${PYTHON_DEPS}
		dev-python/pytest[${PYTHON_USEDEP}]
	)
		"
RDEPEND="sys-fs/fuse-common"

DOCS=( AUTHORS ChangeLog.rst README.md doc/README.NFS doc/kernel.txt )

src_prepare() {
	default

	# lto not supported yet -- https://github.com/libfuse/libfuse/issues/198
	filter-flags -flto

	# passthough_ll is broken on systems with 32-bit pointers
	cat /dev/null > example/meson.build || die
}

multilib_src_configure() {
	meson_src_configure
}

multilib_src_compile() {
	eninja
}

multilib_src_test() {
	python3 -m pytest test || die
}

multilib_src_install() {
	DESTDIR="${D}" eninja install
}

multilib_src_install_all() {
	einstalldocs

	# installed via fuse-common
	rm -r "${ED%/}"/{etc,lib} || die
	rm "${ED%/}"/usr/sbin/mount.fuse3 || die

	# handled by the device manager
	rm -r "${ED%/}"/dev || die

	# manually install man pages
	rm -r "${ED%/}"/usr/share/man || die
	doman doc/fusermount3.1
}
