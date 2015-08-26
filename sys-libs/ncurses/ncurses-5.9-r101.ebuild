# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# This version is just for the ABI .5 library

EAPI="5"

inherit eutils toolchain-funcs multilib-minimal multiprocessing

MY_PV=${PV:0:3}
MY_P=${PN}-${MY_PV}
DESCRIPTION="console display library"
HOMEPAGE="https://www.gnu.org/software/ncurses/ http://dickey.his.com/ncurses/"
SRC_URI="mirror://gnu/ncurses/${MY_P}.tar.gz"

LICENSE="MIT"
# The subslot reflects the SONAME.
SLOT="5/5"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="gpm tinfo unicode"

DEPEND="gpm? ( sys-libs/gpm[${MULTILIB_USEDEP}] )"
# Block the ncurses-5 that installs the same lib. #557472
RDEPEND="${DEPEND}
	!<sys-libs/ncurses-6:0"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PN}-5.8-gfbsd.patch
	"${FILESDIR}"/${PN}-5.7-nongnu.patch
	"${FILESDIR}"/${PN}-5.9-rxvt-unicode-9.15.patch #192083 #383871
	"${FILESDIR}"/${PN}-5.9-fix-clang-build.patch #417763
	"${FILESDIR}"/${PN}-5.9-pkg-config.patch
	"${FILESDIR}"/${P}-no-I-usr-include.patch #522586
	"${FILESDIR}"/${P}-gcc-5.patch #545114
)

src_prepare() {
	epatch "${PATCHES[@]}"
}

src_configure() {
	unset TERMINFO #115036
	tc-export_build_env BUILD_{CC,CPP}
	BUILD_CPPFLAGS+=" -D_GNU_SOURCE" #214642

	# Build the various variants of ncurses -- narrow, wide, and threaded. #510440
	# Order matters here -- we want unicode/thread versions to come last so that the
	# binaries in /usr/bin support both wide and narrow.
	# The naming is also important as we use these directly with filenames and when
	# checking configure flags.
	NCURSES_TARGETS=(
		ncurses
		$(usex unicode 'ncursesw' '')
	)

	multijob_init

	# When installing ncurses, we have to use a compatible version of tic.
	# This comes up when cross-compiling, doing multilib builds, upgrading,
	# or installing for the first time.  Build a local copy of tic whenever
	# the host version isn't available. #249363 #557598
	if ! ROOT=/ has_version "~sys-libs/${P}" ; then
		# We can't re-use the multilib BUILD_DIR because we run outside of it.
		BUILD_DIR="${WORKDIR}" \
		CHOST=${CBUILD} \
		CFLAGS=${BUILD_CFLAGS} \
		CXXFLAGS=${BUILD_CXXFLAGS} \
		CPPFLAGS=${BUILD_CPPFLAGS} \
		LDFLAGS="${BUILD_LDFLAGS} -static" \
		multijob_child_init do_configure cross --without-shared --with-normal
	fi
	multilib-minimal_src_configure
	multijob_finish
}

multilib_src_configure() {
	local t
	for t in "${NCURSES_TARGETS[@]}" ; do
		multijob_child_init do_configure "${t}"
	done
}

do_configure() {
	local target=$1
	shift

	mkdir "${BUILD_DIR}/${target}"
	cd "${BUILD_DIR}/${target}" || die

	local conf=(
		# We need the basic terminfo files in /etc, bug #37026.  We will
		# add '--with-terminfo-dirs' and then populate /etc/terminfo in
		# src_install() ...
		--with-terminfo-dirs="${EPREFIX}/etc/terminfo:${EPREFIX}/usr/share/terminfo"

		# Now the rest of the various standard flags.
		--without-hashed-db
		--disable-pc-files
		--with-shared
		--without-hashed-db
		--without-ada
		--without-cxx
		--without-cxx-binding
		--without-debug
		--without-profile
		# The configure script uses ldd to parse the linked output which
		# is flaky for cross-compiling/multilib/ldd versions/etc...
		$(use_with gpm gpm libgpm.so.1)
		--disable-termcap
		--enable-symlinks
		--with-rcs-ids
		--with-manpage-format=normal
		--enable-const
		--enable-colorfgbg
		--enable-echo
		--disable-warnings
		--without-assertions
		--enable-leaks
		--without-expanded
		--with-macros
		--without-progs
		--without-tests
		--without-trace
		$(use_with tinfo termlib)

		# The chtype/mmask-t settings below are to retain ABI compat
		# with ncurses-5.4 so dont change em !
		--with-chtype=long
		--with-mmask-t=long
		--disable-ext-colors
		--disable-ext-mouse
		--without-{pthread,reentrant}
	)

	if [[ ${target} == ncurses*w ]] ; then
		conf+=( --enable-widec )
	else
		conf+=( --disable-widec )
	fi
	# Make sure each variant goes in a unique location.
	if [[ ${target} != "ncurses" ]] ; then
		conf+=( --includedir="${EPREFIX}"/usr/include/${target} )
	fi
	# See comments in src_configure.
	if [[ ${target} != "cross" ]] ; then
		local tic_path="${WORKDIR}/cross/progs/tic"
		[[ -d ${tic_path} ]] && export TIC_PATH=${tic_path}
	else
		conf+=( --with-progs )
	fi

	# Force bash until upstream rebuilds the configure script with a newer
	# version of autotools. #545532
	CONFIG_SHELL=/bin/bash \
	ECONF_SOURCE=${S} \
	econf "${conf[@]}" "$@"
}

src_compile() {
	# See comments in src_configure.
	if ! ROOT=/ has_version "~sys-libs/${P}" ; then
		BUILD_DIR="${WORKDIR}" \
		do_compile cross -C progs tic
	fi

	multilib-minimal_src_compile
}


multilib_src_compile() {
	local t
	for t in "${NCURSES_TARGETS[@]}" ; do
		do_compile "${t}"
	done
}

do_compile() {
	local target=$1
	shift

	cd "${BUILD_DIR}/${target}" || die

	# A little hack to fix parallel builds ... they break when
	# generating sources so if we generate the sources first (in
	# non-parallel), we can then build the rest of the package
	# in parallel.  This is not really a perf hit since the source
	# generation is quite small.
	emake -j1 sources
	emake "$@"
}

multilib_src_install() {
	local target lib
	for target in "${NCURSES_TARGETS[@]}" ; do
		cd "${BUILD_DIR}/${target}/lib" || die
		for lib in *5.9 ; do
			newlib.so "${lib}" "${lib%%.9}"
		done
	done
}
