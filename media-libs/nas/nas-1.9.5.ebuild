# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib multilib-minimal toolchain-funcs

DESCRIPTION="Network Audio System"
HOMEPAGE="https://radscan.com/nas.html"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="HPND MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86"
IUSE="doc static-libs"

RDEPEND="
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau[${MULTILIB_USEDEP}]
	x11-libs/libXaw
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt[${MULTILIB_USEDEP}]"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	app-text/rman
	sys-devel/bison
	sys-devel/flex
	sys-devel/gcc
	x11-misc/gccmakedep
	riscv? ( x11-misc/xorg-cf-files )
	>=x11-misc/imake-1.0.8-r1"

DOCS=( BUILDNOTES FAQ HISTORY README RELEASE TODO )

PATCHES=(
	"${FILESDIR}/${PN}-1.9.2-asneeded.patch"
	"${FILESDIR}/${PN}-1.9.4-libfl.patch"
)

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	# Need to run econf so that config.guess is updated
	pushd config || die
	econf
	popd || die
	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-$(get_abi_CHOST ${DEFAULT_ABI})-gcc $(get_abi_CFLAGS) -E}" \
		xmkmf -a || die
}

multilib_src_compile() {
	# EXTRA_LDOPTIONS, SHLIBGLOBALSFLAGS #336564#c2
	local emakeopts=(
		AR="$(tc-getAR) cq"
		AS="$(tc-getAS)"
		CC="$(tc-getCC)"
		CDEBUGFLAGS="${CFLAGS}"
		CXX="$(tc-getCXX)"
		CXXDEBUFLAGS="${CXXFLAGS}"
		EXTRA_LDOPTIONS="${LDFLAGS}"
		LD="$(tc-getLD)"
		MAKE="${MAKE:-gmake}"
		RANLIB="$(tc-getRANLIB)"
		SHLIBGLOBALSFLAGS="${LDFLAGS}"
		WORLDOPTS=
	)

	if multilib_is_native_abi ; then
		# dumb fix for parallel make issue wrt #446598, Imake sux
		emake "${emakeopts[@]}" -C server/dia all
		emake "${emakeopts[@]}" -C server/dda/voxware all
		emake "${emakeopts[@]}" -C server/os all
	else
		sed -i \
			-e 's/SUBDIRS =.*/SUBDIRS = include lib config/' \
			Makefile || die
	fi

	emake "${emakeopts[@]}"
}

multilib_src_install() {
	# ranlib is used at install phase too wrt #446600
	emake RANLIB="$(tc-getRANLIB)" \
		DESTDIR="${D}" USRLIBDIR=/usr/$(get_libdir) \
		install install.man
}

multilib_src_install_all() {
	einstalldocs
	if use doc; then
		docinto doc
		dodoc doc/{actions,protocol.txt,README}
		docinto pdf
		dodoc doc/pdf/*.pdf
	fi

	mv -vf "${D}"/etc/nas/nasd.conf{.eg,} || die

	newconfd "${FILESDIR}"/nas.conf.d nas
	newinitd "${FILESDIR}"/nas.init.d nas

	if ! use static-libs; then
		rm -f "${D}"/usr/lib*/libaudio.a || die
	fi
}
