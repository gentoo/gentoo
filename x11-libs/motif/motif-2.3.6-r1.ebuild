# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic multilib toolchain-funcs multilib-minimal

DESCRIPTION="The Motif user interface component toolkit"
HOMEPAGE="https://sourceforge.net/projects/motif/
	http://motif.ics.com/"
SRC_URI="mirror://sourceforge/project/motif/Motif%20${PV}%20Source%20Code/${P}.tar.gz
	http://dev.gentoo.org/~ulm/distfiles/${P}-patches-2.tar.xz"

LICENSE="LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="examples jpeg +motif22-compatibility png static-libs unicode xft"

RDEPEND=">=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXmu-1.1.1-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libXp-1.0.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}]
	jpeg? ( >=virtual/jpeg-0-r2:0=[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.6.10:0=[${MULTILIB_USEDEP}] )
	unicode? ( >=virtual/libiconv-0-r1[${MULTILIB_USEDEP}] )
	xft? (
		>=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}]
		>=x11-libs/libXft-2.3.1-r1[${MULTILIB_USEDEP}]
	)"

DEPEND="${RDEPEND}
	sys-devel/flex
	|| ( dev-util/byacc sys-freebsd/freebsd-ubin )
	x11-misc/xbitmaps"

src_prepare() {
	eapply ../patch
	eapply_user

	# disable compilation of demo binaries
	sed -i -e '/^SUBDIRS/{:x;/\\$/{N;bx;};s/[ \t\n\\]*demos//;}' Makefile.am

	# add X.Org vendor string to aliases for virtual bindings
	echo -e '"The X.Org Foundation"\t\t\t\t\tpc' >>bindings/xmbind.alias

	# remove header file which shouldn't be in the tarball #578168
	rm lib/Xm/Xm.h || die

	AT_M4DIR=. eautoreconf

	# get around some LANG problems in make (#15119)
	LANG=C

	# bug #80421
	filter-flags -ftracer

	# feel free to fix properly if you care
	append-flags -fno-strict-aliasing

	# for Solaris Xos_r.h :(
	[[ ${CHOST} == *-solaris2.11 ]] \
		&& append-cppflags -DNEED_XOS_R_H -DHAVE_READDIR_R_3

	if use !elibc_glibc && use !elibc_uclibc && use !elibc_musl \
			&& use unicode; then
		# libiconv detection in configure script doesn't always work
		# http://bugs.motifzone.net/show_bug.cgi?id=1423
		export LIBS="${LIBS} -liconv"
	fi

	# "bison -y" causes runtime crashes #355795
	export YACC=byacc

	# remember the name of the C compiler for the native ABI
	MY_NATIVE_CC=$(tc-getCC)
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--with-x \
		$(use_enable static-libs static) \
		$(use_enable motif22-compatibility) \
		$(use_enable unicode utf8) \
		$(use_enable xft) \
		$(use_enable jpeg) \
		$(use_enable png)
}

multilib_src_compile() {
	# The wmluiltok build tool is linked with libfl.a, so always
	# compile it for the native ABI
	emake -C tools/wml CC="${MY_NATIVE_CC}" LIBS="-lfl" wmluiltok
	emake
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
	rm -rf "${ED}"/usr/share/Xm
	find "${D}" -type f -name "*.la" -delete || die

	dodoc BUGREPORT ChangeLog README RELEASE RELNOTES TODO
}
