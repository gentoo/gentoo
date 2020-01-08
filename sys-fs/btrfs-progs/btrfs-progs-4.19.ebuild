# Copyright 2008-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit bash-completion-r1 python-single-r1

libbtrfs_soname=0

if [[ ${PV} != 9999 ]]; then
	MY_PV="v${PV/_/-}"
	[[ "${PV}" = *_rc* ]] || \
	KEYWORDS="alpha amd64 arm ~arm64 ~ia64 ~mips ppc ppc64 ~sparc x86"
	SRC_URI="https://www.kernel.org/pub/linux/kernel/people/kdave/${PN}/${PN}-${MY_PV}.tar.xz"
	S="${WORKDIR}"/${PN}-${MY_PV}
else
	WANT_LIBTOOL=none
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/kdave/btrfs-progs.git"
	EGIT_BRANCH="devel"
fi

DESCRIPTION="Btrfs filesystem utilities"
HOMEPAGE="https://btrfs.wiki.kernel.org"

LICENSE="GPL-2"
SLOT="0/${libbtrfs_soname}"
IUSE="+convert python reiserfs static static-libs +zstd"

RESTRICT=test # tries to mount repared filesystems

RDEPEND="
	dev-libs/lzo:2=
	sys-apps/util-linux:0=[static-libs(+)?]
	sys-libs/zlib:0=
	convert? (
		sys-fs/e2fsprogs:0=
		sys-libs/e2fsprogs-libs:0=
		reiserfs? (
			>=sys-fs/reiserfsprogs-3.6.27
		)
	)
	python? ( ${PYTHON_DEPS} )
	zstd? ( app-arch/zstd:0= )
"
DEPEND="${RDEPEND}
	convert? ( sys-apps/acl )
	>=app-text/asciidoc-8.6.0
	app-text/docbook-xml-dtd:4.5
	app-text/xmlto
	python? ( dev-python/setuptools[${PYTHON_USEDEP}] )
	static? (
		dev-libs/lzo:2[static-libs(+)]
		sys-apps/util-linux:0[static-libs(+)]
		sys-libs/zlib:0[static-libs(+)]
		convert? (
			sys-fs/e2fsprogs:0[static-libs(+)]
			sys-libs/e2fsprogs-libs:0[static-libs(+)]
			reiserfs? (
				>=sys-fs/reiserfsprogs-3.6.27[static-libs(+)]
			)
		)
		zstd? ( app-arch/zstd:0[static-libs(+)] )
	)
"

if [[ ${PV} == 9999 ]]; then
	DEPEND+=" sys-devel/gnuconfig"
fi

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}"/${P}-be-bswap.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	if [[ ${PV} == 9999 ]]; then
		AT_M4DIR=m4 eautoreconf
		mkdir config || die
		local automakedir="$(autotools_run_tool --at-output automake --print-libdir)"
		[[ -e ${automakedir} ]] || die "Could not locate automake directory"
		ln -s "${automakedir}"/install-sh config/install-sh || die
		ln -s "${EPREFIX}"/usr/share/gnuconfig/config.guess config/config.guess || die
		ln -s "${EPREFIX}"/usr/share/gnuconfig/config.sub config/config.sub || die
	fi
}

src_configure() {
	local myeconfargs=(
		--bindir="${EPREFIX}"/sbin
		$(use_enable convert)
		$(use_enable elibc_glibc backtrace)
		$(use_enable python)
		$(use_enable static-libs static)
		$(use_enable zstd)
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
