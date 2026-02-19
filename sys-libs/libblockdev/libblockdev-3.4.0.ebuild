# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit autotools python-single-r1 xdg-utils

DESCRIPTION="Library for manipulating block devices"
HOMEPAGE="https://github.com/storaged-project/libblockdev"

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/storaged-project/libblockdev.git"
	BDEPEND="
		dev-build/autoconf-archive
	"
else
	SRC_URI="https://github.com/storaged-project/${PN}/releases/download/${PV}/${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
fi

LICENSE="LGPL-2+"
SLOT="0/3" # subslot is SOVERSION
IUSE="+cryptsetup device-mapper escrow gtk-doc introspection lvm +nvme python smart test +tools"
RESTRICT="!test? ( test )"

# sys-fs/e2fsprogs: required by --with-fs
# virtual/libudev: required at top-level
RDEPEND="
	>=dev-libs/glib-2.42.2
	>=dev-libs/libbytesize-0.1
	sys-apps/gptfdisk
	>=sys-apps/kmod-19
	>=sys-apps/util-linux-2.30
	sys-fs/e2fsprogs:=
	virtual/libudev:=
	cryptsetup? (
		>=sys-apps/keyutils-1.5.0:=
		>=sys-fs/cryptsetup-2.8.0:=
		escrow? (
			>=dev-libs/nss-3.18.0
			dev-libs/volume_key
		)
	)
	device-mapper? ( sys-fs/lvm2 )
	lvm? (
		dev-libs/libyaml
		sys-fs/lvm2
		virtual/udev
	)
	nvme? ( >=sys-libs/libnvme-1.3:= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pygobject:3[${PYTHON_USEDEP}]
		')
	)
	smart? (
		>=dev-libs/json-glib-1.0
		sys-apps/smartmontools
	)
	tools? (
		>=sys-block/parted-3.2
	)
"
DEPEND="${RDEPEND}"
BDEPEND+="
	dev-build/gtk-doc-am
	gtk-doc? ( dev-util/gtk-doc )
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2 )
	test? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-libs/libbytesize[python,${PYTHON_USEDEP}]
			dev-python/dbus-python[${PYTHON_USEDEP}]
			dev-python/pyyaml[${PYTHON_USEDEP}]
		')
		sys-apps/lsb-release
		sys-block/targetcli-fb
	)
"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( ${PYTHON_REQUIRED_USE} )
	escrow? ( cryptsetup )
	test? ( introspection lvm )
"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.4-add-non-systemd-method-for-distro-info.patch"
)

pkg_setup() {
	if use python || use test ; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	default

	xdg_environment_reset # bug #623992

	# bug #744289
	find -type f \( -name "Makefile.am" -o -name "configure.ac" \) -print0 \
		| xargs --null sed "s@ -Werror@@" -i || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-btrfs
		--with-fs
		--with-part
		--without-mpath
		--without-nvdimm
		# dev-libs/libatasmart is inactive upstream, so we just
		# have USE=smart control sys-apps/smartmontools use.
		--without-smart

		$(use_enable introspection)
		$(use_enable test tests)
		$(use_with cryptsetup crypto)
		$(use_with device-mapper dm)
		$(use_with escrow)
		$(use_with gtk-doc)
		$(use_with lvm lvm)
		$(use_with lvm lvm-dbus)
		$(use_with nvme)
		$(use_with python python3)
		$(use_with smart smartmontools)
		$(use_with tools)
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	# See http://storaged.org/libblockdev/ch03.html
	# Largest subset which doesn't require root privileges
	"${EPYTHON}" tests/run_tests.py --include-tags extradeps sourceonly || die
}

src_install() {
	default

	find "${ED}" -type f -name "*.la" -delete || die

	# This is installed even with USE=-lvm, but libbd_lvm are omitted so it
	# doesn't work at all.
	if ! use lvm ; then
		rm -f "${ED}"/usr/bin/lvm-cache-stats || die
	fi

	# bug #718576
	if use python ; then
		python_optimize
	fi
}
