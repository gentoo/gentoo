# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This version is just for the ABI .5 library

EAPI=7

inherit flag-o-matic toolchain-funcs multilib-minimal preserve-libs usr-ldscript

MY_PV="${PV:0:3}"
MY_P="${PN/-compat}-${MY_PV}"
MY_PN="${PN/-compat}"

DESCRIPTION="console display library (ABI version 5)"
HOMEPAGE="https://www.gnu.org/software/ncurses/ https://invisible-island.net/ncurses/"
SRC_URI="mirror://gnu/ncurses/${MY_P}.tar.gz"

if [[ "${PV}" == *_p* ]] ; then
	SRC_URI+=" ftp://ftp.invisible-island.net/ncurses/${PV/_p*}/${MY_PN}-${PV/_p/-}-patch.sh.bz2
		https://invisible-mirror.net/archives/ncurses/${PV/_p*}/${MY_PN}-${PV/_p/-}-patch.sh.bz2"
fi

LICENSE="MIT"
# The subslot reflects the SONAME.
SLOT="5/5"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86"
IUSE="gpm tinfo unicode"

DEPEND="gpm? ( sys-libs/gpm[${MULTILIB_USEDEP}] )"
# Block the ncurses-5 that installs the same lib. #557472
RDEPEND="${DEPEND}
	!<sys-libs/ncurses-6:0
	!sys-libs/ncurses:5"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/ncurses-5.7-nongnu.patch"
	"${FILESDIR}/ncurses-6.0-rxvt-unicode-9.15.patch" #192083 #383871
	"${FILESDIR}/ncurses-6.0-pkg-config.patch"
	"${FILESDIR}/ncurses-5.9-gcc-5.patch" #545114
	"${FILESDIR}/ncurses-6.0-ticlib.patch" #557360
	"${FILESDIR}/ncurses-6.0-cppflags-cross.patch" #601426
)

src_prepare() {
	if [[ "${PV}" == *_p* ]] ; then
		eapply "${WORKDIR}/${MY_PN}-${PV/_p/-}-patch.sh"
	fi
	default
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

	# When installing ncurses, we have to use a compatible version of tic.
	# This comes up when cross-compiling, doing multilib builds, upgrading,
	# or installing for the first time.  Build a local copy of tic whenever
	# the host version isn't available. #249363 #557598
	if ! ROOT=/ has_version -b "~sys-libs/${P}:0" ; then
		local lbuildflags="-static"

		# some toolchains don't quite support static linking
		local dbuildflags="-Wl,-rpath,${WORKDIR}/lib"
		case ${CHOST} in
			*-darwin*)  dbuildflags=     ;;
			*-aix*)     dbuildflags=     ;;
		esac
		echo "int main() {}" | \
			$(tc-getCC) -o x -x c - ${lbuildflags} -pipe >& /dev/null \
			|| lbuildflags="${dbuildflags}"

		# We can't re-use the multilib BUILD_DIR because we run outside of it.
		BUILD_DIR="${WORKDIR}" \
		CHOST=${CBUILD} \
		CFLAGS=${BUILD_CFLAGS} \
		CXXFLAGS=${BUILD_CXXFLAGS} \
		CPPFLAGS=${BUILD_CPPFLAGS} \
		LDFLAGS="${BUILD_LDFLAGS} ${lbuildflags}" \
		do_configure cross --without-shared --with-normal
	fi
	multilib-minimal_src_configure
}

multilib_src_configure() {
	local t
	for t in "${NCURSES_TARGETS[@]}" ; do
		do_configure "${t}"
	done
}

do_configure() {
	local target=$1
	shift

	mkdir "${BUILD_DIR}/${target}" || die
	cd "${BUILD_DIR}/${target}" || die

	local conf=(
		# We need the basic terminfo files in /etc, bug #37026.  We will
		# add '--with-terminfo-dirs' and then populate /etc/terminfo in
		# src_install() ...
		##--with-rel-version=5.9 ??
		--with-abi-version=5
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
		local cross_path="${WORKDIR}/cross"
		[[ -d ${cross_path} ]] && export TIC_PATH="${cross_path}/progs/tic"
	else
		conf+=( --with-progs )
	fi

	# Force bash until upstream rebuilds the configure script with a newer
	# version of autotools. #545532
	CONFIG_SHELL="${EPREFIX}"/bin/bash \
	ECONF_SOURCE="${S}" \
	econf "${conf[@]}" "$@"
}

src_compile() {
	# See comments in src_configure.
	if ! ROOT=/ has_version -b "~sys-libs/${P}:0" ; then
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
	# For some reason, sources depends on pc-files which depends on
	# compiled libraries which depends on sources which ...
	# Manually delete the pc-files file so the install step will
	# create the .pc files we want.
	rm -f misc/pc-files || die
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
