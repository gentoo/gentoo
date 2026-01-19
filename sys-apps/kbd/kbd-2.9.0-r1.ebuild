# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multiprocessing

if [[ ${PV} == 9999 ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/legionus/kbd.git https://git.kernel.org/pub/scm/linux/kernel/git/legion/kbd.git"
	EGIT_BRANCH="master"
else
	if [[ $(ver_cut 3) -lt 90 ]] ; then
		SRC_URI="https://www.kernel.org/pub/linux/utils/kbd/${P}.tar.xz"
		KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
	else
		inherit autotools
		SRC_URI="https://github.com/legionus/kbd/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	fi
fi

DESCRIPTION="Keyboard and console utilities"
HOMEPAGE="https://kbd-project.org/"

LICENSE="GPL-2+"
SLOT="0"
IUSE="bzip2 lzma nls selinux pam test zlib zstd"
RESTRICT="!test? ( test )"

DEPEND="
	app-alternatives/gzip
	bzip2? ( app-arch/bzip2 )
	lzma? ( app-arch/xz-utils )
	pam? (
		!app-misc/vlock
		sys-libs/pam
	)
	zlib? ( virtual/zlib:= )
	zstd? ( app-arch/zstd:= )
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-loadkeys )
"
BDEPEND="
	sys-devel/flex
	virtual/pkgconfig
	test? ( dev-libs/check )
"

PATCHES=(
	"${FILESDIR}"/${P}-install-no-attr.patch
	"${FILESDIR}"/${P}-install-posix.patch
	"${FILESDIR}"/${P}-nullptr.patch
	"${FILESDIR}"/${P}-uninit.patch
	"${FILESDIR}"/${P}-time64.patch
)

src_prepare() {
	default

	# Rename conflicting keymaps to have unique names, bug #293228
	# See also https://github.com/legionus/kbd/issues/76.
	pushd "${S}"/data/keymaps/i386 &> /dev/null || die
	mv fgGIod/trf.map fgGIod/trf-fgGIod.map || die
	mv olpc/es.map olpc/es-olpc.map || die
	mv olpc/pt.map olpc/pt-olpc.map || die
	mv qwerty/cz.map qwerty/cz-qwerty.map || die
	popd &> /dev/null || die

	#if [[ ${PV} == 9999 ]] || [[ $(ver_cut 3) -ge 90 ]] ; then
	#	eautoreconf
	#fi

	# Drop after 2.9.0
	eautoreconf
}

src_configure() {
	# https://github.com/legionus/kbd/issues/121
	unset LEX

	local myeconfargs=(
		--disable-werror
		# No Valgrind for the testsuite
		--disable-memcheck

		$(use_enable nls)
		$(use_enable pam vlock)
		$(use_enable test tests)
		$(use_with bzip2)
		$(use_with lzma)
		$(use_with zlib)
		$(use_with zstd)
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	emake -Onone check TESTSUITEFLAGS="--jobs=$(get_makeopts_jobs)"
}

src_install() {
	default

	# USE="test" installs .la files
	find "${ED}" -type f -name "*.la" -delete || die
}
