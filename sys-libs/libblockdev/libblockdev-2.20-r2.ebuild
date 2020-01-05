# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7}} )
inherit autotools python-single-r1 xdg-utils

MY_PV="${PV}-1"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A library for manipulating block devices"
HOMEPAGE="https://github.com/storaged-project/libblockdev"
SRC_URI="https://github.com/storaged-project/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ia64 ~mips ppc ppc64 sparc x86"
IUSE="bcache +cryptsetup device-mapper dmraid doc escrow lvm kbd test vdo"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.42.2
	dev-libs/libbytesize
	>=sys-apps/kmod-19
	>=sys-apps/util-linux-2.27
	>=sys-block/parted-3.1
	cryptsetup? (
		escrow? (
			>=dev-libs/nss-3.18.0
			dev-libs/volume_key
		)
		>=sys-fs/cryptsetup-1.6.7:=
	)
	device-mapper? ( sys-fs/lvm2 )
	dmraid? (
		sys-fs/dmraid
		sys-fs/lvm2
	)
	lvm? (
		sys-fs/lvm2
		virtual/udev
	)
	vdo? ( dev-libs/libyaml )
	${PYTHON_DEPS}
"

DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-libs/gobject-introspection-1.3.0
	sys-devel/autoconf-archive
	doc? ( dev-util/gtk-doc )
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
		escrow? ( cryptsetup )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	xdg_environment_reset #623992
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-btrfs
		--with-fs
		--with-part
		--without-mpath
		--without-nvdimm
		$(use_enable test tests)
		$(use_with bcache)
		$(use_with cryptsetup crypto)
		$(use_with device-mapper dm)
		$(use_with dmraid)
		$(use_with doc gtk-doc)
		$(use_with escrow)
		$(use_with kbd)
		$(use_with lvm lvm)
		$(use_with lvm lvm-dbus)
		$(use_with vdo)
	)
	if python_is_python3 ; then
		myeconfargs+=(
			--without-python2
			--with-python3
		)
	else
		myeconfargs+=(
			--with-python2
			--without-python3
		)
	fi
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name "*.la" -delete || die
}
