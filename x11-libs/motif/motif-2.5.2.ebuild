# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal toolchain-funcs virtualx

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/thentenaar/motif.git"
	EGIT_BRANCH="master"
else
	SRC_URI="https://github.com/thentenaar/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos ~x64-solaris"
fi

DESCRIPTION="The Motif user interface component toolkit"
HOMEPAGE="https://github.com/thentenaar/motif"

LICENSE="LGPL-2.1+ MIT"
SLOT="0/5"
IUSE="examples jpeg png static-libs unicode +xcursor xft +xrandr +xrender"
REQUIRED_USE="test? ( jpeg png xft )"

RDEPEND="x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXmu[${MULTILIB_USEDEP}]
	x11-libs/libXpm[${MULTILIB_USEDEP}]
	x11-libs/libXt[${MULTILIB_USEDEP}]
	jpeg? ( media-libs/libjpeg-turbo:0=[${MULTILIB_USEDEP}] )
	png? ( media-libs/libpng:0=[${MULTILIB_USEDEP}] )
	unicode? ( virtual/libiconv[${MULTILIB_USEDEP}] )
	xcursor? ( x11-libs/libXcursor[${MULTILIB_USEDEP}] )
	xft? (
		media-libs/fontconfig[${MULTILIB_USEDEP}]
		x11-libs/libXft[${MULTILIB_USEDEP}]
	)
	xrandr? ( x11-libs/libXrandr[${MULTILIB_USEDEP}] )
	xrender? ( x11-libs/libXrender[${MULTILIB_USEDEP}] )"

DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-misc/xbitmaps
	test? (
		dev-libs/check[${MULTILIB_USEDEP}]
		media-fonts/font-misc-misc
	)"

BDEPEND="sys-devel/flex
	dev-util/byacc"

src_prepare() {
	default

	AT_M4DIR=. eautoreconf

	if use !elibc_glibc && use !elibc_musl; then
		# libiconv detection in configure script doesn't always work
		# http://bugs.motifzone.net/show_bug.cgi?id=1423
		export LIBS="${LIBS} -liconv"
	fi

	# avoid mismatch of lex variants #936172
	export LEX=flex
	# "bison -y" causes runtime crashes #355795
	export YACC=byacc

	# remember the name of the C compiler for the native ABI
	MY_NATIVE_CC=$(tc-getCC)
}

multilib_src_configure() {
	local myconf=(
		$(use_enable static-libs static)
		$(use_enable test tests)
		$(use_enable unicode utf8)
		$(use_with jpeg)
		$(use_with png)
		$(use_with xcursor)
		$(use_with xft)
		$(use_with xrandr)
		$(use_with xrender)
	)
	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_compile() {
	if ! multilib_is_native_abi; then
		# The wmluiltok build tool is linked with libfl.a, so always
		# compile it for the native ABI
		emake -C tools/wml CC="${MY_NATIVE_CC}" \
			wmluiltok_LDADD="-lfl" wmluiltok
	fi
	emake

	if multilib_is_native_abi && use examples; then
		emake -C demos
	fi
}

multilib_src_test() {
	virtx emake check
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if multilib_is_native_abi && use examples; then
		emake -C demos DESTDIR="${D}" install-data
		dodir /usr/share/doc/${PF}/demos
		mv "${ED}"/usr/share/Xm/* "${ED}"/usr/share/doc/${PF}/demos || die
	fi
}

multilib_src_install_all() {
	# mwm default configs
	insinto /usr/share/X11/app-defaults
	newins "${FILESDIR}"/Mwm.defaults Mwm

	# cleanup
	rm -rf "${ED}"/usr/share/Xm || die
	find "${D}" -type f -name "*.la" -delete || die

	dodoc README.md
}
