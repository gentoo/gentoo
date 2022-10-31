# Copyright 2008-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit bash-completion-r1 python-single-r1 udev

libbtrfs_soname=0

if [[ ${PV} != 9999 ]]; then
	MY_PV="v${PV/_/-}"
	SRC_URI="https://www.kernel.org/pub/linux/kernel/people/kdave/${PN}/${PN}-${MY_PV}.tar.xz"

	if [[ ${PV} != *_rc* ]] ; then
		KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
	fi

	S="${WORKDIR}"/${PN}-${MY_PV}
else
	EGIT_REPO_URI="https://github.com/kdave/btrfs-progs.git"
	EGIT_BRANCH="devel"
	WANT_LIBTOOL="none"
	inherit autotools git-r3
fi

DESCRIPTION="Btrfs filesystem utilities"
HOMEPAGE="https://btrfs.wiki.kernel.org https://btrfs.readthedocs.io/en/latest/"

LICENSE="GPL-2"
SLOT="0/${libbtrfs_soname}"
IUSE="+convert python +man reiserfs static static-libs udev +zstd"
# Could support it with just !systemd => eudev, see mdadm, but let's
# see if someone asks for it first.
REQUIRED_USE="static? ( !udev )"

# Tries to mount repaired filesystems
RESTRICT="test"

RDEPEND="
	dev-libs/lzo:2=
	sys-apps/util-linux:=[static-libs(+)?]
	sys-libs/zlib:=
	convert? (
		sys-fs/e2fsprogs:=
		reiserfs? (
			>=sys-fs/reiserfsprogs-3.6.27
		)
	)
	python? ( ${PYTHON_DEPS} )
	udev? ( virtual/libudev:= )
	zstd? ( app-arch/zstd:= )
"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-5.10
	convert? ( sys-apps/acl )
	python? (
		$(python_gen_cond_dep '
			dev-python/setuptools[${PYTHON_USEDEP}]
		')
	)
	static? (
		dev-libs/lzo:2[static-libs(+)]
		sys-apps/util-linux:0[static-libs(+)]
		sys-libs/zlib:0[static-libs(+)]
		convert? (
			sys-fs/e2fsprogs[static-libs(+)]
			reiserfs? (
				>=sys-fs/reiserfsprogs-3.6.27[static-libs(+)]
			)
		)
		zstd? ( app-arch/zstd[static-libs(+)] )
	)
"
BDEPEND="virtual/pkgconfig
	man? ( dev-python/sphinx )"

if [[ ${PV} == 9999 ]]; then
	BDEPEND+=" sys-devel/gnuconfig"
fi

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	if [[ ${PV} == 9999 ]]; then
		AT_M4DIR="m4" eautoreconf

		mkdir config || die
		local automakedir="$(autotools_run_tool --at-output automake --print-libdir)"
		[[ -e ${automakedir} ]] || die "Could not locate automake directory"

		ln -s "${automakedir}"/install-sh config/install-sh || die
		ln -s "${BROOT}"/usr/share/gnuconfig/config.guess config/config.guess || die
		ln -s "${BROOT}"/usr/share/gnuconfig/config.sub config/config.sub || die
	fi
}

src_configure() {
	local myeconfargs=(
		--bindir="${EPREFIX}"/sbin

		--enable-lzo
		--disable-experimental
		$(use_enable convert)
		$(use_enable man documentation)
		$(use_enable elibc_glibc backtrace)
		$(use_enable python)
		$(use_enable static-libs static)
		$(use_enable udev libudev)
		$(use_enable zstd)

		# Could support libgcrypt, libsodium, libkcapi
		--with-crypto=builtin
		--with-convert=ext2$(usex reiserfs ',reiserfs' '')
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake V=1 all $(usev static)
}

src_install() {
	local makeargs=(
		$(usex python install_python '')
		$(usex static install-static '')
	)

	emake V=1 DESTDIR="${D}" install "${makeargs[@]}"

	newbashcomp btrfs-completion btrfs

	use python && python_optimize
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
