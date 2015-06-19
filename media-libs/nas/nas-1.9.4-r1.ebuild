# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/nas/nas-1.9.4-r1.ebuild,v 1.1 2015/04/29 16:40:13 blueness Exp $

EAPI=5
inherit eutils multilib toolchain-funcs multilib-minimal

DESCRIPTION="Network Audio System"
HOMEPAGE="http://radscan.com/nas.html"
SRC_URI="mirror://sourceforge/${PN}/${P}.src.tar.gz"

LICENSE="HPND MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc static-libs"

RDEPEND="x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	>=x11-libs/libXau-1.0.7-r1[${MULTILIB_USEDEP}]
	x11-libs/libXaw
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXpm
	>=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	app-text/rman
	sys-devel/bison
	sys-devel/flex
	x11-misc/gccmakedep
	x11-misc/imake
	>=x11-proto/xproto-7.0.24[${MULTILIB_USEDEP}]"

DOCS=( BUILDNOTES FAQ HISTORY README RELEASE TODO )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.9.2-asneeded.patch
	epatch "${FILESDIR}"/${PN}-1.9.4-remove-abs-fabs.patch

	multilib_copy_sources
}

multilib_src_configure() {
	xmkmf -a || die
}

multilib_src_compile() {
	# EXTRA_LDOPTIONS, SHLIBGLOBALSFLAGS #336564#c2
	local emakeopts=(
		AR="$(tc-getAR) clq"
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

	emake "${emakeopts[@]}" World
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

	use static-libs || rm -f "${D}"/usr/lib*/libaudio.a
}
