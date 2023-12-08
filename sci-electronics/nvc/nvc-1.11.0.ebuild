# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=16

inherit autotools bash-completion-r1 llvm

DESCRIPTION="NVC is a VHDL compiler and simulator"
HOMEPAGE="https://www.nickg.me.uk/nvc/
	https://github.com/nickg/nvc/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/nickg/nvc.git"

	NVC_SOURCEDIR="${WORKDIR}"/${PN}-${PV}
else
	SRC_URI="https://github.com/nickg/nvc/archive/r${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"

	NVC_SOURCEDIR="${WORKDIR}"/${PN}-r${PV}
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="debug llvm"
RESTRICT="test"         # Some tests fail.

RDEPEND="
	app-arch/bzip2:=
	app-arch/zstd:=
	dev-libs/capstone:=
	dev-libs/elfutils
	dev-libs/icu:=
	dev-libs/libffi:=
	dev-libs/libxml2:=
	sys-libs/ncurses:=
	sys-libs/zlib:=
	llvm? ( <sys-devel/llvm-$((${LLVM_MAX_SLOT} + 1)):= )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-libs/check
	sys-devel/bison
	sys-devel/flex
"

NVC_BUILDDIR="${NVC_SOURCEDIR}_BuildDir"
S="${NVC_BUILDDIR}"

PATCHES=( "${FILESDIR}/nvc-1.9.2-jit-code-capstone.patch" )

# Special libraries for NVC.
QA_FLAGS_IGNORED="usr/lib[0-9]*/nvc/preload[0-9]*.so"

pkg_setup() {
	use llvm && llvm_pkg_setup
}

src_unpack() {
	default

	mkdir -p "${S}" || die
}

src_prepare() {
	pushd "${NVC_SOURCEDIR}" >/dev/null || die

	default
	eautoreconf

	popd >/dev/null || die
}

src_configure() {
	# Needs "bison" and "flex" exactly.
	unset LEX
	unset YACC

	local ECONF_SOURCE="${NVC_SOURCEDIR}"
	local -a myconf=(
		--enable-verilog
		--enable-vital
		--with-bash-completion="$(get_bashcompdir)"
		$(use_enable debug)
		$(use_enable llvm)
	)
	econf "${myconf[@]}"

	export V=1          # Verbose compilation and install.
}

src_compile() {
	emake -j1
}

src_test() {
	PATH="${S}/bin:${PATH}" emake check
}

src_install() {
	default

	mv "${D}/$(get_bashcompdir)"/nvc{.bash,} || die

	dostrip -x "/usr/$(get_libdir)/nvc"
}
