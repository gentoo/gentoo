# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/thomasdickey.asc
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
GENTOO_PATCH_PV=6.3_p20220924
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
		20211026
		20211030
		20211106
		20211113
		20211115
		20211120
		20211127
		20211204
		20211211
		20211219
		20211225
		20220101
		20220115
		20220122
		20220129
		20220205
		20220212
		20220219
		20220226
		20220305
		20220312
		20220319
		20220326
		20220402
		20220409
		20220416
		20220423
		20220430
		20220501
		20220507
		20220514
		20220521
		20220529
		20220604
		20220612
		20220618
		20220625
		20220703
		20220709
		20220716
		20220724
		20220729
		20220806
		20220813
		20220820
		20220827
		20220903
		20220910
		20220917

		# Latest patch is just _pN = $(ver_cut 4)
		$(ver_cut 4)
	)

	if [[ -z ${PATCH_DATES[@]} ]] ; then
		SRC_URI+=" https://invisible-island.net/archives/${PN}/${PV/_p*}/${P/_p/-}.patch.sh.gz"
		SRC_URI+=" verify-sig? ( https://invisible-island.net/archives/${PN}/${PV/_p*}/${P/_p/-}.patch.sh.gz.asc"

		# If we have a rollup patch, use that instead of the individual ones.
		UPSTREAM_PATCHES+=( "${WORKDIR}"/${P/_p/-}-patch.sh )
	else
		patch_url=
		my_patch_index=

		# We keep a bunch of mirrors here as we've had reports of invisible*.net
		# being 403 forbidden for some users.
		urls=(
			"https://invisible-island.net/archives/${PN}/${PV/_p*}/${MY_P}-%s"
			"https://invisible-mirror.net/archives/${PN}/${PV/_p*}/${MY_P}-%s"
			"https://dev.gentoo.org/~${GENTOO_PATCH_DEV}/distfiles/${CATEGORY}/${PN}/${MY_P}-%s"
		)

		for ((my_patch_index=0; my_patch_index < "${#PATCH_DATES[@]}"; my_patch_index++)); do
			for url in "${urls[@]}" ; do
				patch_url="$(printf ${urls} ${PATCH_DATES[${my_patch_index}]}.patch.gz)"
				SRC_URI+=" ${patch_url}"
				SRC_URI+=" verify-sig? ( ${patch_url}.asc )"
			done

			UPSTREAM_PATCHES+=( "${WORKDIR}"/${MY_P}-${PATCH_DATES[${my_patch_index}]}.patch )
		done

		unset patch_url
		unset my_patch_index
		unset urls
	fi

	SRC_URI+=" https://dev.gentoo.org/~${GENTOO_PATCH_DEV}/distfiles/${CATEGORY}/${PN}/${GENTOO_PATCH_NAME}.tar.xz"
fi

LICENSE="MIT"
# The subslot reflects the SONAME.
SLOT="0/6"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="ada +cxx debug doc gpm minimal profile +stack-realign static-libs test tinfo trace"
RESTRICT="!test? ( test )"

DEPEND="gpm? ( sys-libs/gpm[${MULTILIB_USEDEP}] )"
# Block the older ncurses that installed all files w/SLOT=5, bug #557472
RDEPEND="${DEPEND}
	!<=sys-libs/ncurses-5.9-r4:5
	!<sys-libs/slang-2.3.2_pre23
	!<x11-terms/rxvt-unicode-9.06-r3
	!<x11-terms/st-0.6-r1"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-thomasdickey )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${UPSTREAM_PATCHES[@]}"

	# When rebasing Gentoo's patchset, please use git from a clean
	# src_unpack with upstream patches already applied. git am --reject
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

	tc-export_build_env BUILD_{CC,CPP}

	# bug #214642
	BUILD_CPPFLAGS+=" -D_GNU_SOURCE"

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
		CHOST=${CBUILD} \
		CFLAGS=${BUILD_CFLAGS} \
		CXXFLAGS=${BUILD_CXXFLAGS} \
		CPPFLAGS=${BUILD_CPPFLAGS} \
		LDFLAGS="${BUILD_LDFLAGS} ${lbuildflags}" \
		do_configure cross --without-shared --with-normal --with-progs
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

	# https://lists.gnu.org/archive/html/bug-ncurses/2022-09/msg00024.html
	export EGREP="grep -E"
	export FGREP="grep -F"

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
		# Required for building  on mingw-w64, and possibly other windows
		# platforms, bug #639670
		$(use_enable kernel_Winnt term-driver)
		--disable-termcap
		--enable-symlinks
		--with-rcs-ids
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
		# We could possibly merge these two branches but opting to be
		# conservative when merging some of the Prefix changes.

		if [[ ${CHOST} == *-cygwin* ]] && ! multilib_is_native_abi ; then
			# We make 'tic$(x)' here, for Cygwin having x=".exe".
			BUILD_DIR="${WORKDIR}" \
				 do_compile cross -C progs all PROGS='tic$(x)'
		else
			BUILD_DIR="${WORKDIR}" \
				 do_compile cross -C progs tic
		fi
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

	if ! tc-is-static-only ; then
		# Provide a link for -lcurses.
		ln -sf libncurses$(get_libname) "${ED}"/usr/$(get_libdir)/libcurses$(get_libname) || die
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
}

multilib_src_install_all() {
	# We need the basic terminfo files in /etc for embedded/recovery, bug #37026
	einfo "Installing basic terminfo files in /etc..."
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
	local x
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
