# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson multilib-minimal

DESCRIPTION="An interface for filesystems implemented in userspace"
HOMEPAGE="https://github.com/libfuse/libfuse"
SRC_URI="https://github.com/libfuse/libfuse/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="3"
#KEYWORDS="~amd64"
RESTRICT="test"

DEPEND="
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog.rst README.md doc/README.NFS doc/kernel.txt )

src_prepare() {
	default
	# passthough_ll is broken on systems with 32-bit pointers
	cat /dev/null > example/meson.build || die
}

multilib_src_configure() {
	meson_src_configure
}

multilib_src_compile() {
	eninja
}

multilib_src_install() {
	DESTDIR="${D}" eninja install
}

multilib_src_install_all() {
	einstalldocs
	rm "${ED%/}"/dev/fuse || die
	rmdir "${ED%/}"/dev || die
	rm "${ED%/}"/etc/init.d/fuse3 || die
	rmdir "${ED%/}"/etc{/init.d,} || die
	mv "${ED%/}"/usr/share/man/man8/mount.fuse{,3}.8.gz || die
}
