# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit meson udev

EGIT_COMMIT="b4b7e5606f785572b78a43626a27a45fe3df2fbd"
DESCRIPTION="Content-Addressable Data Synchronization Tool"
HOMEPAGE="https://github.com/systemd/casync"
SRC_URI="https://github.com/systemd/casync/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+fuse +udev man selinux test"
RESTRICT="!test? ( test )"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

RDEPEND="
	app-arch/xz-utils:=
	app-arch/zstd:=
	dev-libs/openssl:0=
	net-misc/curl:=
	virtual/acl:=
	fuse? ( sys-fs/fuse:0= )
	selinux? ( sys-libs/libselinux:= )
	udev? ( virtual/libudev:= )
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
		-Dudev="$(usex udev true false)"
	)
	meson_src_configure
}
