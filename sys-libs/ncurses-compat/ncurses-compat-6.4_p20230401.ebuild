# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This version is just for the ABI .5 library.
# sys-libs/ncurses-compat can be bumped with sys-libs/ncurses as upstream
# provide a configure option (which we use here) for the ABI version.

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/thomasdickey.asc
inherit flag-o-matic toolchain-funcs multilib multilib-minimal verify-sig

MY_PV="${PV:0:3}"
MY_P="${PN/-compat}-${MY_PV}"
MY_PN="${PN/-compat}"

DESCRIPTION="Console display library (ABI version 5)"
HOMEPAGE="https://www.gnu.org/software/ncurses/ https://invisible-island.net/ncurses/"

# Keep invisible-mirror.net here as some users reported 403 forbidden with invisible-island.net
SRC_URI="
	mirror://gnu/ncurses/${MY_P}.tar.gz
	https://invisible-island.net/archives/${MY_PN}/${MY_P}.tar.gz
	https://invisible-mirror.net/archives/${MY_PN}/${MY_P}.tar.gz
	verify-sig? ( mirror://gnu/ncurses/${MY_P}.tar.gz.sig )
"

GENTOO_PATCH_DEV=sam
GENTOO_PATCH_PV=6.4_p20230408
GENTOO_PATCH_NAME=${MY_PN}-${GENTOO_PATCH_PV}-patches

# Populated below in a loop. Do not add patches manually here.
UPSTREAM_PATCHES=()

if [[ ${PV} == *_p* ]] ; then
	# Sometimes, after releases, there's no megapatch available yet.
	#
	# From upstream README at e.g. https://invisible-island.net/archives/ncurses/6.3/:
	#
	#	"At times (generally to mark a relatively stable point), I create a rollup
	#	patch, which consists of all changes from the release through the current date."
	#
	# Also, from https://lists.gnu.org/archive/html/bug-ncurses/2019-08/msg00039.html,
	# the patches are considered to be acceptable to use after some testing. They
	# are both for development but also bug fixes.
	#
	# This array should contain a list of all the snapshots since the last
	# release if there's no megapatch available yet.
	PATCH_DATES=(
		20230107
		20230114
		20230121
		20230128
		20230211
		20230218
		20230225
		20230311

		# Latest patch is just _pN = $(ver_cut 4)
		$(ver_cut 4)
	)

	if [[ -z ${PATCH_DATES[@]} ]] ; then
		SRC_URI+=" https://invisible-island.net/archives/${MY_PN}/${PV/_p*}/${MY_P/_p/-}.patch.sh.gz"
		SRC_URI+=" verify-sig? ( https://invisible-island.net/archives/${MY_PN}/${PV/_p*}/${MY_P/_p/-}.patch.sh.gz.asc"

		# If we have a rollup patch, use that instead of the individual ones.
		UPSTREAM_PATCHES+=( patch.sh )
	else
		# We use a mirror as well because we've had reports of 403 forbidden for some users.
		upstream_url_base="https://invisible-island.net/archives/${MY_PN}/${PV/_p*}/${MY_P}-"
		upstream_m_url_base="https://invisible-mirror.net/archives/${MY_PN}/${PV/_p*}/${MY_P}-"

		# Prefix each date with the upstream location (https://invisible-island.net/archives/${MY_PN}/${PV/_p*}/${MY_P})
		mangled_patches=( "${PATCH_DATES[@]/#/${upstream_url_base}}" )
		# Suffix each with .patch.gz
		mangled_patches=( "${mangled_patches[@]/%/.patch.gz}" )
		mangled_patches_sig=( "${mangled_patches[@]/%/.asc}" )
		# Repeat for .patch.gz.asc for verify-sig
		SRC_URI+=" ${mangled_patches[@]}"
		SRC_URI+=" verify-sig? ( ${mangled_patches_sig[@]} )"

		# For all of the URLs, chuck in invisible-island.net too:
		SRC_URI+=" ${mangled_patches[@]/${upstream_url_base}/${upstream_m_url_base}}"
		SRC_URI+=" verify-sig? ( ${mangled_patches_sig[@]/${upstream_url_base}/${upstream_m_url_base}} )"

		UPSTREAM_PATCHES=( "${PATCH_DATES[@]/%/.patch}" )

		unset upstream_url_base upstream_m_url_base mangled_patches mangled_patches_sig
	fi
fi

SRC_URI+=" https://dev.gentoo.org/~${GENTOO_PATCH_DEV}/distfiles/${CATEGORY}/${MY_PN}/${GENTOO_PATCH_NAME}.tar.xz"

LICENSE="MIT"
# The subslot reflects the SONAME.
SLOT="5/5"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="gpm +stack-realign tinfo unicode"

DEPEND="gpm? ( sys-libs/gpm[${MULTILIB_USEDEP}] )"
# Block the ncurses-5 that installs the same lib, bug #557472
RDEPEND="
	${DEPEND}
	!<sys-libs/ncurses-6:0
	!sys-libs/ncurses:5
"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-thomasdickey )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${UPSTREAM_PATCHES[@]/#/${WORKDIR}/${MY_P}-}"

	# When rebasing Gentoo's patchset, please use git from a clean
	# src_prepare with upstream patches already applied. git am --reject
	# the existing patchset and rebase as required. This makes it easier
	# to manage future rebasing & adding new patches.
	#
	# For the same reasons, please include the original configure.in changes,
	# NOT just the generated results!
	"${WORKDIR}"/${GENTOO_PATCH_NAME}
)

src_unpack() {
	# Avoid trying to verify our own patchset tarball, there's no point
	if use verify-sig ; then
		local file
		for file in ${A} ; do
			if [[ ${file} == ${MY_P}.tar.gz ]] ; then
				verify-sig_verify_detached "${DISTDIR}"/${file} "${DISTDIR}"/${file}.sig
			else
				[[ ${file} == @(*${GENTOO_PATCH_NAME}.tar.xz|*.asc|*.sig) ]] && continue

				verify-sig_verify_detached "${DISTDIR}"/${file} "${DISTDIR}"/${file}.asc
			fi
		done
	fi

	default
}

src_configure() {
	# bug #115036
	unset TERMINFO

	tc-export_build_env BUILD_{CC,CXX,CPP}

	# bug #214642
	BUILD_CPPFLAGS+=" -D_GNU_SOURCE"

	# Build the various variants of ncurses -- narrow, wide, and threaded. #510440
	# Order matters here -- we want unicode/thread versions to come last so that the
	# binaries in /usr/bin support both wide and narrow.
	# The naming is also important as we use these directly with filenames and when
	# checking configure flags.
	NCURSES_TARGETS=(
		ncurses
		$(usev unicode 'ncursesw')
	)

	# When installing ncurses, we have to use a compatible version of tic.
	# This comes up when cross-compiling, doing multilib builds, upgrading,
	# or installing for the first time.  Build a local copy of tic whenever
	# the host version isn't available. bug #249363, bug #557598
	if ! has_version -b "~sys-libs/${P}:0" ; then
		local lbuildflags="-static"

		# some toolchains don't quite support static linking
		local dbuildflags="-Wl,-rpath,${WORKDIR}/lib"
		case ${CHOST} in
			*-darwin*)  dbuildflags=     ;;
		esac
		echo "int main() {}" | \
			$(tc-getCC) -o x -x c - ${lbuildflags} -pipe >& /dev/null \
			|| lbuildflags="${dbuildflags}"

		# We can't re-use the multilib BUILD_DIR because we run outside of it.
		BUILD_DIR="${WORKDIR}" \
		CC=${BUILD_CC} \
		CXX=${BUILD_CXX} \
		CPP=${BUILD_CPP} \
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
	if [[ ${ABI} == x86 ]] ; then
		# For compatibility with older binaries at slight performance cost.
		# bug #616402
		use stack-realign && append-flags -mstackrealign
	fi

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

	ECONF_SOURCE="${S}" econf "${conf[@]}" "$@"
}

src_compile() {
	# See comments in src_configure.
	if ! has_version -b "~sys-libs/${P}:0" ; then
		BUILD_DIR="${WORKDIR}" do_compile cross -C progs tic$(get_exeext)
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
