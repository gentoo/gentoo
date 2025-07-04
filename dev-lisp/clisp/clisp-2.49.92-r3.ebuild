# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo flag-o-matic toolchain-funcs xdg-utils

DESCRIPTION="Portable, bytecode-compiled implementation of Common Lisp"
HOMEPAGE="https://clisp.sourceforge.io/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="2/8"
KEYWORDS="~alpha ~amd64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
# "jit" disabled ATM
IUSE="hyperspec X berkdb dbus fastcgi gdbm gtk +pcre postgres +readline svm threads +unicode +zlib"
# Needs work still
RESTRICT="test"

RDEPEND="
	>=dev-lisp/asdf-2.33-r3
	>=dev-libs/libsigsegv-2.10
	>=dev-libs/ffcall-1.10
	virtual/libcrypt:=
	virtual/libiconv
	dbus? ( sys-apps/dbus )
	fastcgi? ( dev-libs/fcgi )
	gdbm? ( sys-libs/gdbm:= )
	gtk? (
		>=gnome-base/libglade-2.6
		>=x11-libs/gtk+-2.10:2
	)
	postgres? ( >=dev-db/postgresql-8.0:* )
	readline? ( >=sys-libs/readline-7.0:= )
	pcre? ( dev-libs/libpcre:3 )
	svm? ( sci-libs/libsvm )
	zlib? ( sys-libs/zlib )
	X? ( x11-libs/libXpm )
	hyperspec? ( dev-lisp/hyperspec )
	berkdb? ( sys-libs/db:5.3 )
"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )
"
BDEPEND="X? ( x11-misc/imake )"

PATCHES=(
	"${FILESDIR}"/${P}-after_glibc_cfree_bdb.patch
	"${FILESDIR}"/${P}-gdbm_and_bdb5.3.patch
	"${FILESDIR}"/${P}-build-Build-genclx-without-gnulib.patch
)

BUILDDIR="builddir"

enable_modules() {
	[[ $# = 0 ]] && die "${FUNCNAME[0]} must receive at least one argument"

	local m
	for m in "$@" ; do
		einfo "Enabling module ${m}"
		myconf+=( --with-module=${m} )
	done
}

src_prepare() {
	default

	# More than -O1 breaks alpha
	if use alpha; then
		sed -i -e 's/-O2//g' src/makemake.in || die
	fi

	xdg_environment_reset
}

src_configure() {
	# Not local so enable_modules() can use it
	myconf=(
		--prefix="${EPREFIX}"/usr
		--libdir="${EPREFIX}"/usr/$(get_libdir)
		--enable-portability
		$(use_with readline)
		$(use_with unicode)
		--hyperspec=${CLHSROOT}
	)

	# Temporary workaround for bug #932564 with GCC 15
	# This can be dropped with a new release.
	strip-flags
	tc-is-gcc && {
		append-flags -fno-tree-dce -fno-tree-dse -fno-tree-pta
	}

	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/856103
	# https://gitlab.com/gnu-clisp/clisp/-/issues/49
	filter-lto

	if use alpha; then
		# We need this to build on alpha
		replace-flags -O? -O1
	elif use x86; then
		# bug #585182
		append-flags -falign-functions=4
	fi

	# built-in features
	myconf+=(
		--with-ffcall
		--without-dynamic-modules
	)

	# There's a problem with jit_allocai function
	#if use jit; then
	#	myconf+=" --with-jitc=lightning"
	#fi

	if use threads; then
		myconf+=( --with-threads=POSIX_THREADS )
	fi

	# modules not enabled:
	#  * berkdb: must figure out a way to make the configure script pick up the
	#            currect version of the library and headers
	#  * dirkey: fails to compile, requiring windows.h, possibly wrong #ifdefs
	#  * matlab, netica: not in portage
	#  * oracle: can't install oracle-instantclient
	#
	# default modules
	enable_modules rawsock
	# optional modules
	use elibc_glibc && enable_modules bindings/glibc
	use X && enable_modules clx/new-clx
	if use postgres; then
		enable_modules postgresql
		append-cppflags -I$(pg_config --includedir)
	fi
	if use berkdb; then
		enable_modules berkeley-db
		append-cppflags -I"${EPREFIX}"/usr/include/db5.3
	fi
	use dbus && enable_modules dbus
	use fastcgi && enable_modules fastcgi
	use gdbm && enable_modules gdbm
	use gtk && enable_modules gtk2
	use pcre && enable_modules pcre
	use svm && enable_modules libsvm
	use zlib && enable_modules zlib

	if use hyperspec; then
		CLHSROOT="file://${EPREFIX}/usr/share/hyperspec/HyperSpec/"
	else
		CLHSROOT="http://www.lispworks.com/reference/HyperSpec/"
	fi

	myconf+=(
		--config
		CC="$(tc-getCC)"
		CFLAGS="${CFLAGS}"
		LDFLAGS="${LDFLAGS}"
	)

	# configure chokes on --sysconfdir option
	edo ./configure "${myconf[@]}" ${BUILDDIR}

	IMPNOTES="file://${EPREFIX}/usr/share/doc/${PN}-${PVR}/html/impnotes.html"
	sed -i "s,http://clisp.cons.org/impnotes/,${IMPNOTES},g" \
		"${BUILDDIR}"/config.lisp || die "Cannot fix link to implementation notes"
}

src_compile() {
	export VARTEXFONTS="${T}"/fonts
	# parallel build fails
	emake -C "${BUILDDIR}" -j1
}

src_test() {
	emake -C "${BUILDDIR}" -j1 check
	# Test non-portable features and modules
	emake -C "${BUILDDIR}" -j1 extracheck mod-check
}

src_install() {
	pushd "${BUILDDIR}" || die
	emake -j1 DESTDIR="${D}" prefix="${EPREFIX}"/usr install-bin
	doman clisp.1
	dodoc ../SUMMARY README* ../src/NEWS ../unix/MAGIC.add ../ANNOUNCE
	popd || die

	dodoc doc/{CLOS-guide,LISP-tutorial}.txt
	docinto html
	dodoc doc/impnotes.{css,html} doc/regexp.html doc/clisp.png
}
