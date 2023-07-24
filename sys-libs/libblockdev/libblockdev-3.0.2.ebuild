# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit autotools python-single-r1 xdg-utils

DESCRIPTION="A library for manipulating block devices"
HOMEPAGE="https://github.com/storaged-project/libblockdev"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/storaged-project/libblockdev.git"
	BDEPEND="
		sys-devel/autoconf-archive
	"
else
	MY_PV="${PV}-1"
	SRC_URI="https://github.com/storaged-project/${PN}/releases/download/${MY_PV}/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~mips ~ppc64 ~riscv ~x86"
fi
LICENSE="LGPL-2+"
SLOT="0/3"	# subslot is SOVERSION
IUSE="+cryptsetup device-mapper escrow gtk-doc introspection lvm +nvme test +tools"
# Tests require root. In a future release, we may be able to run a smaller
# subset with new run_tests.py arguments.
RESTRICT="!test? ( test ) test"

RDEPEND="
	>=dev-libs/glib-2.42.2
	dev-libs/libbytesize
	sys-apps/gptfdisk
	>=sys-apps/kmod-19
	>=sys-apps/util-linux-2.27
	>=sys-block/parted-3.1
	cryptsetup? (
		escrow? (
			>=dev-libs/nss-3.18.0
			dev-libs/volume_key
		)
		>=sys-apps/keyutils-1.5.0:=
		>=sys-fs/cryptsetup-2.3.0:=
	)
	device-mapper? ( sys-fs/lvm2 )
	lvm? (
		sys-fs/lvm2
		virtual/udev
	)
	nvme? ( sys-libs/libnvme )
	${PYTHON_DEPS}
"

DEPEND="
	${RDEPEND}
"

BDEPEND+="
	dev-util/gtk-doc-am
	gtk-doc? ( dev-util/gtk-doc )
	introspection? ( >=dev-libs/gobject-introspection-1.3.0 )
	test? (
		$(python_gen_cond_dep '
			dev-libs/libbytesize[python,${PYTHON_USEDEP}]
		')
		sys-block/targetcli-fb
	)
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
		escrow? ( cryptsetup )"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	xdg_environment_reset #623992
	default

	# https://bugs.gentoo.org/744289
	find -type f \( -name "Makefile.am" -o -name "configure.ac" \) -print0 \
		| xargs --null sed "s@ -Werror@@" -i || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-btrfs
		--with-fs
		--with-part
		--with-python3
		--without-mpath
		--without-nvdimm
		$(use_enable introspection)
		$(use_enable test tests)
		$(use_with cryptsetup crypto)
		$(use_with device-mapper dm)
		$(use_with escrow)
		$(use_with gtk-doc)
		$(use_with lvm lvm)
		$(use_with lvm lvm-dbus)
		$(use_with nvme)
		$(use_with tools)
	)
	econf "${myeconfargs[@]}"
}

src_test() {
	# See http://storaged.org/libblockdev/ch03.html
	# The 'check' target just does Pylint.
	# ... but it needs root.
	emake test
}

src_install() {
	default
	find "${ED}" -type f -name "*.la" -delete || die
	# This is installed even with USE=-lvm, but libbd_lvm are omitted so it
	# doesn't work at all.
	if ! use lvm ; then
		rm -f "${ED}"/usr/bin/lvm-cache-stats || die
	fi
	python_optimize #718576
}
