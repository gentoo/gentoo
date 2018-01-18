# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )
inherit autotools python-single-r1

MY_PV="${PV}-1"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A library for manipulating block devices"
HOMEPAGE="https://github.com/rhinstaller/libblockdev"
SRC_URI="https://github.com/rhinstaller/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="bcache +cryptsetup dmraid doc lvm kbd test"

CDEPEND="
	>=dev-libs/glib-2.42.2
	dev-libs/libbytesize
	>=sys-apps/util-linux-2.27
	>=sys-block/parted-3.1
	cryptsetup? (
		>=dev-libs/nss-3.18.0
		dev-libs/volume_key
		>=sys-fs/cryptsetup-1.6.7:=
	)
	dmraid? (
		sys-fs/dmraid
		sys-fs/lvm2
	)
	lvm? (
		sys-fs/lvm2
		virtual/udev
	)
	kbd? ( >=sys-apps/kmod-19 )
	${PYTHON_DEPS}
"

DEPEND="
	${CDEPEND}
	>=dev-libs/gobject-introspection-1.3.0
	doc? ( dev-util/gtk-doc )
"

RDEPEND="
	${CDEPEND}
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-btrfs
		--with-fs
		--with-part
		--with-python3
		--without-mpath
		$(use_enable test tests)
		$(use_with bcache)
		$(use_with cryptsetup crypto)
		$(use_with dmraid dm)
		$(use_with doc gtk-doc)
		$(use_with lvm lvm)
		$(use_with lvm lvm-dbus)
		$(use_with kbd)
	)
	econf "${myeconfargs[@]}"
}
