# Copyright 2008-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit bash-completion-r1 python-single-r1 udev

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/kdave/btrfs-progs.git"
	EGIT_BRANCH="devel"
	WANT_LIBTOOL="none"
	inherit autotools git-r3
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/dsterba.asc
	inherit verify-sig

	MY_PV="v${PV/_/-}"
	MY_P="${PN}-${MY_PV}"
	SRC_URI="
		https://www.kernel.org/pub/linux/kernel/people/kdave/${PN}/${MY_P}.tar.xz
		verify-sig? ( https://www.kernel.org/pub/linux/kernel/people/kdave/${PN}/${MY_P}.tar.sign )
	"
	S="${WORKDIR}"/${PN}-${MY_PV}

	if [[ ${PV} != *_rc* ]] ; then
		KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
	fi
fi

DESCRIPTION="Btrfs filesystem utilities"
HOMEPAGE="https://btrfs.readthedocs.io/en/latest/"

LICENSE="GPL-2"
SLOT="0/0" # libbtrfs soname
IUSE="+convert python +man reiserfs static static-libs udev +zstd"
# Could support it with just !systemd => eudev, see mdadm, but let's
# see if someone asks for it first.
REQUIRED_USE="static? ( !udev ) python? ( ${PYTHON_REQUIRED_USE} )"

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
DEPEND="
	${RDEPEND}
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
BDEPEND="
	virtual/pkgconfig
	man? (
		dev-python/sphinx
		dev-python/sphinx-rtd-theme
	)
"

if [[ ${PV} == 9999 ]]; then
	BDEPEND+=" sys-devel/gnuconfig"
else
	BDEPEND+=" verify-sig? ( sec-keys/openpgp-keys-dsterba )"
fi

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
		return
	fi

	if in_iuse verify-sig && use verify-sig ; then
		mkdir "${T}"/verify-sig || die
		pushd "${T}"/verify-sig &>/dev/null || die

		# Upstream sign the decompressed .tar
		# Let's do it separately in ${T} then cleanup to avoid external
		# effects on normal unpack.
		cp "${DISTDIR}"/${MY_P}.tar.xz . || die
		xz -d ${MY_P}.tar.xz || die
		verify-sig_verify_detached ${MY_P}.tar "${DISTDIR}"/${MY_P}.tar.sign

		popd &>/dev/null || die
		rm -r "${T}"/verify-sig || die
	fi

	default
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

		# Could support libgcrypt, libsodium, libkcapi, openssl, botan
		--with-crypto=builtin
		--with-convert=ext2$(usev reiserfs ',reiserfs')
	)

	export EXTRA_PYTHON_CFLAGS="${CFLAGS}"
	export EXTRA_PYTHON_LDFLAGS="${LDFLAGS}"

	# bash as a tepmorary workaround for https://github.com/kdave/btrfs-progs/pull/721
	CONFIG_SHELL="${BROOT}"/bin/bash econf "${myeconfargs[@]}"
}

src_compile() {
	emake V=1 all $(usev static)
}

src_test() {
	emake V=1 -j1 -C tests test

	if use python ; then
		cd libbtrfsutil/python || die

		local -x LD_LIBRARY_PATH="${S}:libbtrfsutil/python:${LD_LIBRARY_PATH}"
		${EPYTHON} -m unittest tests/test_*.py || die "Tests failed with ${EPYTHON}"
	fi
}

src_install() {
	local makeargs=(
		$(usev python install_python)
		$(usev static install-static)
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
