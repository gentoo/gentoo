# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# sys-libs/ncurses-compat can be bumped with sys-libs/ncurses as upstream
# provide a configure option for the ABI version.

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/thomasdickey.asc
inherit flag-o-matic toolchain-funcs multilib multilib-minimal preserve-libs usr-ldscript verify-sig

MY_PV="${PV:0:3}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="Console display library"
HOMEPAGE="https://www.gnu.org/software/ncurses/ https://invisible-island.net/ncurses/"
# Keep invisible-mirror.net here as some users reported 403 forbidden with invisible-island.net
SRC_URI="
	mirror://gnu/ncurses/${MY_P}.tar.gz
	https://invisible-island.net/archives/${PN}/${MY_P}.tar.gz
	https://invisible-mirror.net/archives/${PN}/${MY_P}.tar.gz
	verify-sig? ( mirror://gnu/ncurses/${MY_P}.tar.gz.sig )
"

GENTOO_PATCH_DEV=sam
GENTOO_PATCH_PV=6.5_p20250301
GENTOO_PATCH_NAME=${PN}-${GENTOO_PATCH_PV}-patches

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
		20240504
		20240511
		20240518
		20240519
		20240525
		20240601
		20240608
		20240615
		20240622
		20240629
		20240706
		20240713
		20240720
		20240727
		20240810
		20240817
		20240824
		20240831
		20240914
		20240922
		20240928
		20241006
		20241019
		20241026
		20241102
		20241109
		20241123
		20241130
		20241207
		20241214
		20241221
		20241228
		20250104
		20250111
		20250118
		20250125
		20250201
		20250208
		20250215
		20250216
		20250222
		20250301
		20250308
		20250315
		20250322

		# Latest patch is just _pN = $(ver_cut 4)
		$(ver_cut 4)
	)

	if [[ -z ${PATCH_DATES[@]} ]] ; then
		SRC_URI+=" https://invisible-island.net/archives/${PN}/${PV/_p*}/${MY_P/_p/-}.patch.sh.gz"
		SRC_URI+=" verify-sig? ( https://invisible-island.net/archives/${PN}/${PV/_p*}/${MY_P/_p/-}.patch.sh.gz.asc"

		# If we have a rollup patch, use that instead of the individual ones.
		UPSTREAM_PATCHES+=( patch.sh )
	else
		# We use a mirror as well because we've had reports of 403 forbidden for some users.
		upstream_url_base="https://invisible-island.net/archives/${PN}/${PV/_p*}/${MY_P}-"
		upstream_m_url_base="https://invisible-mirror.net/archives/${PN}/${PV/_p*}/${MY_P}-"

		# Prefix each date with the upstream location (https://invisible-island.net/archives/${PN}/${PV/_p*}/${MY_P})
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

SRC_URI+=" https://dev.gentoo.org/~${GENTOO_PATCH_DEV}/distfiles/${CATEGORY}/${PN}/${GENTOO_PATCH_NAME}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
# The subslot reflects the SONAME.
SLOT="0/6"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="ada +cxx debug doc gpm minimal profile split-usr +stack-realign static-libs test tinfo trace"
# In 6.5_p20250118, the C++ examples fail to link, but there's no automated
# testsuite anyway. Controlling building examples isn't really what USE=test
# is for. Just restrict them.
RESTRICT="!test? ( test ) test"

# TODO: ncurses allows (and we take advantage of this, even) passing
# the SONAME for dlopen() use, so only the header is needed at build time.
# Maybe we should bundle a copy of gpm.h so we can move gpm to PDEPEND
# which would be far nicer UX-wise.
DEPEND="gpm? ( sys-libs/gpm[${MULTILIB_USEDEP}] )"
# Block the older ncurses that installed all files w/SLOT=5, bug #557472
RDEPEND="
	${DEPEND}
	!<=sys-libs/ncurses-5.9-r4:5
	!<sys-libs/slang-2.3.2_pre23
	!<x11-terms/rxvt-unicode-9.06-r3
	!<x11-terms/st-0.6-r1
	!minimal? ( !<x11-terms/ghostty-1.1.0 )
"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-thomasdickey )"

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

	# NCURSES_BOOL confusion, see https://lists.gnu.org/archive/html/bug-ncurses/2024-11/msg00010.html
	append-cflags $(test-flags-CC -std=gnu17)

	# Build the various variants of ncurses -- narrow, wide, and threaded. #510440
	# Order matters here -- we want unicode/thread versions to come last so that the
	# binaries in /usr/bin support both wide and narrow.
	# The naming is also important as we use these directly with filenames and when
	# checking configure flags.
	NCURSES_TARGETS=(
		ncurses
		ncursesw
		ncursest
		ncursestw
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
			*-solaris*) dbuildflags="-Wl,-R,${WORKDIR}/lib" ;;
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
		do_configure cross --without-shared --with-normal --with-progs --without-ada
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
		--with-terminfo-dirs="${EPREFIX}/etc/terminfo:${EPREFIX}/usr/share/terminfo"

		# Enable installation of .pc files.
		--enable-pc-files
		# This path is used to control where the .pc files are installed.
		--with-pkg-config-libdir="${EPREFIX}/usr/$(get_libdir)/pkgconfig"

		# Now the rest of the various standard flags.
		--with-shared
		--enable-fvisibility
		# (Originally disabled until bug #245417 is sorted out, but now
		# just keeping it off for good, given nobody needed it until now
		# (2022) and we're trying to phase out bdb.)
		--without-hashed-db
		$(use_with ada)
		$(use_with cxx)
		$(use_with cxx cxx-binding)
		--with-cxx-shared
		$(use_with debug)
		$(use_with profile)
		# The configure script uses ldd to parse the linked output which
		# is flaky for cross-compiling/multilib/ldd versions/etc...
		$(use_with gpm gpm libgpm.so.1)

		# bug #930806
		--disable-setuid-environ
		# TODO: Maybe do these for USE=hardened
		#--disable-root-access
		#--disable-root-environ

		--disable-termcap
		--enable-symlinks
		--with-manpage-format=normal
		--enable-const
		--enable-colorfgbg
		--enable-hard-tabs
		--enable-echo
		$(use_enable !ada warnings)
		$(use_with debug assertions)
		$(use_enable !debug leaks)
		$(use_with debug expanded)
		$(use_with !debug macros)
		$(multilib_native_with progs)
		$(use_with test tests)
		$(use_with trace)
		$(use_with tinfo termlib)
		--disable-stripping
		--disable-pkg-ldflags
	)

	case ${CHOST} in
		*-mingw32*)
			conf+=( --enable-term-driver )
			;;
		*)
			conf+=( --disable-term-driver )
			;;
	esac

	if [[ ${target} == ncurses*w ]] ; then
		conf+=( --enable-widec )
	else
		conf+=( --disable-widec )
	fi
	if [[ ${target} == ncursest* ]] ; then
		conf+=( --with-{pthread,reentrant} )
	else
		conf+=( --without-{pthread,reentrant} )
	fi

	# Make sure each variant goes in a unique location.
	if [[ ${target} == "ncurses" ]] ; then
		# "ncurses" variant goes into "${EPREFIX}"/usr/include
		# It is needed on Prefix because the configure script appends
		# "ncurses" to "${prefix}/include" if "${prefix}" is not /usr.
		conf+=( --enable-overwrite )
	else
		conf+=( --includedir="${EPREFIX}"/usr/include/${target} )
	fi
	# See comments in src_configure.
	if [[ ${target} != "cross" ]] ; then
		local cross_path="${WORKDIR}/cross"
		[[ -d ${cross_path} ]] && export TIC_PATH="${cross_path}/progs/tic"
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
	local target
	for target in "${NCURSES_TARGETS[@]}" ; do
		emake -C "${BUILD_DIR}/${target}" DESTDIR="${D}" install
	done

	# Move main libraries into /.
	if multilib_is_native_abi ; then
		gen_usr_ldscript -a \
			"${NCURSES_TARGETS[@]}" \
			$(usex tinfo 'tinfow tinfo' '')
	fi

	# Don't delete '*.dll.a', needed for linking, bug #631468
	if ! use static-libs; then
		find "${ED}"/usr/ -name '*.a' ! -name '*.dll.a' -delete || die
	fi

	# Build fails to create this ...
	# -FIXME-
	# Ugly hackaround for riscv having two parts libdir (bug #689240)
	# Replace this hack with an official solution once we have one...
	# -FIXME-
	dosym $(sed 's@[^/]\+@..@g' <<< $(get_libdir))/share/terminfo \
		/usr/$(get_libdir)/terminfo

	# Remove obsolete libcurses symlink that is created by the build
	# system. Technically, this could be also achieved
	# via --disable-overwrite but it also moves headers implicitly,
	# and we do not want to do this yet.
	# bug #836696
	rm "${ED}"/usr/$(get_libdir)/libcurses* || die
}

multilib_src_install_all() {
	local terms=(
		# Dumb/simple values that show up when using the in-kernel VT.
		ansi console dumb linux
		vt{52,100,102,200,220}
		# [u]rxvt users used to be pretty common.  Probably should drop this
		# since upstream is dead and people are moving away from it.
		rxvt{,-unicode}{,-256color}
		# xterm users are common, as is terminals re-using/spoofing it.
		xterm xterm-{,256}color
		# screen is common (and reused by tmux).
		screen{,-256color}
		screen.xterm-256color
	)
	if use split-usr ; then
		local x
		# We need the basic terminfo files in /etc for embedded/recovery, bug #37026
		einfo "Installing basic terminfo files in /etc..."
		for x in "${terms[@]}"; do
			local termfile=$(find "${ED}"/usr/share/terminfo/ -name "${x}" 2>/dev/null)
			local basedir=$(basename "$(dirname "${termfile}")")

			if [[ -n ${termfile} ]] ; then
				dodir "/etc/terminfo/${basedir}"
				mv "${termfile}" "${ED}/etc/terminfo/${basedir}/" || die
				dosym "../../../../etc/terminfo/${basedir}/${x}" \
					"/usr/share/terminfo/${basedir}/${x}"
			fi
		done

		echo "CONFIG_PROTECT_MASK=\"/etc/terminfo\"" | newenvd - 50ncurses

		use minimal && rm -r "${ED}"/usr/share/terminfo*
		# Because ncurses5-config --terminfo returns the directory we keep it
		# bug #245374
		keepdir /usr/share/terminfo
	elif use minimal ; then
		# Keep only the basic terminfo files
		find "${ED}"/usr/share/terminfo/ \
			\( -type f -o -type l \) ${terms[*]/#/! -name } -delete , \
			-type d -empty -delete || die
	fi

	cd "${S}" || die
	dodoc ANNOUNCE MANIFEST NEWS README* TO-DO doc/*.doc
	if use doc ; then
		docinto html
		dodoc -r doc/html/
	fi
}

pkg_preinst() {
	preserve_old_lib /$(get_libdir)/libncurses.so.5
	preserve_old_lib /$(get_libdir)/libncursesw.so.5
}

pkg_postinst() {
	preserve_old_lib_notify /$(get_libdir)/libncurses.so.5
	preserve_old_lib_notify /$(get_libdir)/libncursesw.so.5
}
