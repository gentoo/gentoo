# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils flag-o-matic multilib toolchain-funcs xdg-utils

DESCRIPTION="A portable, bytecode-compiled implementation of Common Lisp"
HOMEPAGE="https://clisp.sourceforge.io/"
SRC_URI="mirror://sourceforge/clisp/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="2/${PV}"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="hyperspec X berkdb dbus fastcgi gdbm gtk +pcre postgres +readline svm -threads +unicode +zlib"
# "jit" disabled ATM

RDEPEND=">=dev-lisp/asdf-2.33-r3
		 virtual/libiconv
		 >=dev-libs/libsigsegv-2.4
		 >=dev-libs/ffcall-1.10
		 dbus? ( sys-apps/dbus )
		 fastcgi? ( dev-libs/fcgi )
		 gdbm? ( sys-libs/gdbm )
		 gtk? ( >=x11-libs/gtk+-2.10 >=gnome-base/libglade-2.6 )
		 postgres? ( >=dev-db/postgresql-8.0 )
		 readline? ( >=sys-libs/readline-5.0 <sys-libs/readline-7.0 )
		 pcre? ( dev-libs/libpcre )
		 svm? ( sci-libs/libsvm )
		 zlib? ( sys-libs/zlib )
		 X? ( x11-libs/libXpm )
		 hyperspec? ( dev-lisp/hyperspec )
		 berkdb? ( sys-libs/db:4.8 )"
#		 jit? ( >=dev-libs/lightning-1.2 )

DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto x11-misc/imake )"

enable_modules() {
	[[ $# = 0 ]] && die "${FUNCNAME[0]} must receive at least one argument"
	for m in "$@" ; do
		einfo "enabling module $m"
		myconf+=" --with-module=${m}"
	done
}

BUILDDIR="builddir"

# modules not enabled:
#  * berkdb: must figure out a way to make the configure script pick up the
#            currect version of the library and headers
#  * dirkey: fails to compile, requiring windows.h, possibly wrong #ifdefs
#  * matlab, netica: not in portage
#  * oracle: can't install oracle-instantclient

src_prepare() {
	# More than -O1 breaks alpha/ia64
	if use alpha || use ia64; then
		sed -i -e 's/-O2//g' src/makemake.in || die
	fi
	epatch "${FILESDIR}"/${P}-bits_ipctypes_to_sys_ipc.patch
	epatch "${FILESDIR}"/${P}-get_hostname.patch
	epatch "${FILESDIR}"/${P}-tinfo.patch

	xdg_environment_reset
}

src_configure() {
	# Bug 618170. If anyone has a better idea...
	append-flags -fno-pie

	# We need this to build on alpha/ia64
	if use alpha || use ia64; then
		replace-flags -O? -O1
		append-flags '-D NO_MULTIMAP_SHM -D NO_MULTIMAP_FILE -D NO_SINGLEMAP -D NO_TRIVIALMAP'
	fi

	# QA issue with lisp.run
	append-flags -Wa,--noexecstack

	# built-in features
	local myconf="--with-ffcall --without-dynamic-modules"
#    There's a problem with jit_allocai function
#    if use jit; then
#        myconf+=" --with-jitc=lightning"
#    fi
	if use threads; then
		myconf+=" --with-threads=POSIX_THREADS"
	fi

	# default modules
	enable_modules wildcard rawsock
	# optional modules
	use elibc_glibc && enable_modules bindings/glibc
	use X && enable_modules clx/new-clx
	if use postgres; then
		enable_modules postgresql
		append-cppflags -I$(pg_config --includedir)
	fi
	if use berkdb; then
		enable_modules berkeley-db
		append-cppflags -I/usr/include/db4.8
	fi
	use dbus && enable_modules dbus
	use fastcgi && enable_modules fastcgi
	use gdbm && enable_modules gdbm
	use gtk && enable_modules gtk2
	use pcre && enable_modules pcre
	use svm && enable_modules libsvm
	use zlib && enable_modules zlib

	if use hyperspec; then
		CLHSROOT="file:///usr/share/doc/hyperspec/HyperSpec/"
	else
		CLHSROOT="http://www.lispworks.com/reference/HyperSpec/"
	fi

	# configure chokes on --sysconfdir option
	local configure="./configure --prefix=/usr --libdir=/usr/$(get_libdir) \
		$(use_with readline) $(use_with unicode) \
		${myconf} --hyperspec=${CLHSROOT} ${BUILDDIR}"
	einfo "${configure}"
	${configure} || die "./configure failed"

	IMPNOTES="file://${ROOT%/}/usr/share/doc/${PN}-${PVR}/html/impnotes.html"
	sed -i "s,http://clisp.cons.org/impnotes/,${IMPNOTES},g" \
		"${BUILDDIR}"/config.lisp || die "Cannot fix link to implementation notes"
}

src_compile() {
	export VARTEXFONTS="${T}"/fonts
	cd "${BUILDDIR}"
	# parallel build fails
	emake -j1
}

src_install() {
	pushd "${BUILDDIR}"
	make DESTDIR="${D}" prefix=/usr install-bin || die "Installation failed"
	doman clisp.1
	dodoc ../SUMMARY README* ../src/NEWS ../unix/MAGIC.add ../ANNOUNCE
	popd
	dohtml doc/impnotes.{css,html} doc/regexp.html doc/clisp.png
	dodoc doc/{CLOS-guide,LISP-tutorial}.txt
}
