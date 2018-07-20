# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit flag-o-matic toolchain-funcs autotools

PATCH_VER=20170529

if [[ ${PV} == 9999 ]]; then
	EDARCS_REPOSITORY="http://mico.org/mico-darcs-repository"
	inherit darcs
	SRC_URI=
else
	SRC_URI="http://www.mico.org/${P}.tar.gz"
fi

if [[ -n ${PATCH_VER} ]]; then
	SRC_URI+=" https://dev.gentoo.org/~haubi/distfiles/${P}-gentoo-patches-${PATCH_VER}.tar.xz"
	PATCHES=${WORKDIR}/patches
else
	PATCHES=
fi

DESCRIPTION="A freely available and fully compliant implementation of the CORBA standard"
HOMEPAGE="http://www.mico.org/"
LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~sparc-solaris ~x86-winnt"
IUSE="gtk postgres ssl tcl threads X"
RESTRICT="test" #298101

# doesn't compile:
#   bluetooth? ( net-wireless/bluez )

RDEPEND="
	gtk?       ( x11-libs/gtk+:2 )
	postgres?  ( dev-db/postgresql:* )
	ssl?       ( dev-libs/openssl:* )
	tcl?       ( dev-lang/tcl:0 )
	X?         ( x11-libs/libXt )
"
DEPEND="${RDEPEND}
	>=sys-devel/flex-2.5.2
	>=sys-devel/bison-1.22
"

if [[ ${PV} == 9999 ]]; then
	src_unpack() {
		darcs_src_unpack
		default
	}
else
	S=${WORKDIR}/${PN}
fi

src_prepare() {
	default

	eautoreconf

	# cannot use big TOC (AIX only), gdb doesn't like it.
	# This assumes that the compiler (or -wrapper) uses
	# gcc flag '-mminimal-toc' for compilation.
	sed -i -e 's/,-bbigtoc//' "${S}"/configure || die
}

src_configure() {
	tc-export CC CXX

	if use gtk && [[ -n ${PATCH_VER} ]]; then
		# need gtk-1 wrapper for gtk-2
		export PATH="${WORKDIR}"/helpers:${PATH}
	fi

	# Don't know which version of JavaCUP would suffice, but there is no
	# configure argument to disable checking for JavaCUP.
	# So we override the configure check to not find 'javac'.
	export ac_cv_path_JAVAC=no

	# '--without-ssl' just does not add another search path - the only way
	# to disable openssl utilization seems to override the configure check.
	use ssl || export ac_cv_lib_ssl_open=no

	local myconf=
	myconf() {
		myconf="${myconf} $*"
	}

	myconf --disable-mini-stl
	myconf $(use_enable threads)

	# '--without-*' or '--with-*=no' does not disable some features,
	# the value needs to be empty instead.
	# This applies to: gtk, pgsql, qt, tcl, bluetooth.
	myconf --with-gtk=$(  use gtk      && echo "${EPREFIX}"/usr)
	myconf --with-pgsql=$(use postgres && echo "${EPREFIX}"/usr)
	myconf --with-tcl=$(  use tcl      && echo "${EPREFIX}"/usr)
	# bluetooth and wireless both don't compile cleanly
	myconf --with-bluetooth=''
	myconf --disable-wireless
	# But --without-x works.
	myconf $(use_with X x "${EPREFIX}"/usr)

	# http://www.mico.org/pipermail/mico-devel/2009-April/010285.html
	[[ ${CHOST} == *-hpux* ]] && append-cppflags -D_XOPEN_SOURCE_EXTENDED

	if [[ ${CHOST} == *-winnt* ]]; then
		# disabling static libs, since ar on interix takes nearly
		# one hour per library, thanks to mico's monster objects.
		use threads &&
		ewarn "disabling USE='threads', does not work on ${CHOST}"
		myconf --disable-threads --disable-static --enable-final
		append-flags -D__STDC__
	fi

	econf ${myconf}
}

src_install() {
	emake INSTDIR="${ED}"usr SHARED_INSTDIR="${ED}"usr install LDCONFIG=:
	if [[ $(get_libdir) != lib ]]; then #500744
		mv "${ED}"usr/lib "${ED}"usr/$(get_libdir) || die
	fi

	# avoid conflict with net-dns/nsd, bug#544488
	mv "${ED}"usr/bin/{,mico-}nsd || die
	mv "${ED}"usr/man/man8/{,mico-}nsd.8 || die

	# avoid conflict with net-misc/eventd, bug#632170
	mv "${ED}"usr/bin/{,mico-}eventd || die

	dodir /usr/share
	mv "${ED}"usr/man "${ED}"usr/share || die
	dodir /usr/share/doc/${PF}
	mv "${ED}"usr/doc "${ED}"usr/share/doc/${PF} || die

	dodoc BUGS CHANGES* CONVERT FAQ README* ROADMAP TODO VERSION WTODO
}

pkg_postinst() {
	einfo "The MICO Name Service daemon 'nsd' is named 'mico-nsd'"
	einfo "due to a name conflict with net-dns/nsd. For details"
	einfo "please refer to https://bugs.gentoo.org/544488."
	einfo
	einfo "The MICO Event daemon 'eventd' is named 'mico-eventd'"
	einfo "due to a name conflict with net-misc/eventd. For details"
	einfo "please refer to https://bugs.gentoo.org/632170."
}
