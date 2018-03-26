# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit vcs-snapshot meson

COMMIT="a755da21d3ba5d9cbb002dfc86a3ab0d46b82176"
DESCRIPTION=" Content-Addressable Data Synchronization Tool"
HOMEPAGE="https://github.com/systemd/casync"
SRC_URI="https://github.com/systemd/casync/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+fuse +udev man selinux test"

RDEPEND="
	fuse? ( sys-fs/fuse:0 )
	selinux? ( sys-libs/libselinux )
	udev? ( virtual/libudev )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	man? ( dev-python/sphinx )
"

src_configure() {
	local emesonargs=(
		-Dfuse="$(usex fuse true false)"
		-Dman="$(usex man true false)"
		-Dselinux="$(usex selinux true false)"
		-Dtests="$(usex test true false)"
		-Dudev="$(usex udev true false)"
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
