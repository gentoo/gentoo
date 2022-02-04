# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib multilib-minimal preserve-libs usr-ldscript

MY_PV="${PV:0:3}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="console display library"
HOMEPAGE="https://www.gnu.org/software/ncurses/ https://invisible-island.net/ncurses/"
SRC_URI="mirror://gnu/ncurses/${MY_P}.tar.gz
	https://invisible-mirror.net/archives/${PN}/${MY_P}.tar.gz
	ftp://ftp.invisible-island.net/${PN}/${MY_P}.tar.gz"

if [[ "${PV}" == *_p* ]] ; then
	# Sometimes, after releases, there's no megapatch available yet.
	#
	# From upstream README at e.g. https://invisible-mirror.net/archives/ncurses/6.3/:
	#
	#	"At times (generally to mark a relatively stable point), I create a rollup
	#	patch, which consists of all changes from the release through the current date."
	#
	# This array should contain a list of all the snapshots since the last
	# release if there's no megapatch available yet.
	PATCH_DATES=(
		20211026
		20211030
		# Latest patch is just _pN = $(ver_cut 4)
		$(ver_cut 4)
	)

	if [[ -z ${PATCH_DATES[@]} ]] ; then
		SRC_URI+=" ftp://ftp.invisible-island.net/${PN}/${PV/_p*}/${P/_p/-}.patch.sh.bz2
			https://invisible-mirror.net/archives/${PN}/${PV/_p*}/${P/_p/-}.patch.sh.bz2"
	else
		patch_date=
		for patch_date in "${PATCH_DATES[@]}" ; do
			SRC_URI+=" ftp://ftp.invisible-island.net/${PN}/${PV/_p*}/${MY_P}-${patch_date}.patch.gz"
			SRC_URI+=" https://invisible-mirror.net/archives/${PN}/${PV/_p*}/${MY_P}-${patch_date}.patch.gz"
		done
		unset patch_date
	fi

	#SRC_URI+=" https://dev.gentoo.org/~polynomial-c/dist/${P}.patch.xz"
fi

LICENSE="MIT"
# The subslot reflects the SONAME.
SLOT="0/6"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="ada +cxx debug doc gpm minimal profile static-libs test tinfo trace"
RESTRICT="!test? ( test )"

DEPEND="gpm? ( sys-libs/gpm[${MULTILIB_USEDEP}] )"
#	berkdb? ( sys-libs/db )"
# Block the older ncurses that installed all files w/SLOT=5. #557472
RDEPEND="${DEPEND}
	!<=sys-libs/ncurses-5.9-r4:5
	!<sys-libs/slang-2.3.2_pre23
	!<x11-terms/rxvt-unicode-9.06-r3
	!<x11-terms/st-0.6-r1"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${PN}-5.7-nongnu.patch"
	"${FILESDIR}/${PN}-6.0-rxvt-unicode-9.15.patch" #192083 #383871
	"${FILESDIR}/${PN}-6.0-pkg-config.patch"
	"${FILESDIR}/${PN}-6.0-ticlib.patch" #557360
	"${FILESDIR}/${PN}-6.2_p20210123-cppflags-cross.patch" #601426
)

src_prepare() {
	if [[ "${PV}" == *_p* ]] ; then
		#eapply "${WORKDIR}"/${P/_p/-}-patch.sh
		eapply "${WORKDIR}"/
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
		ncursesw
		ncursest
		ncursestw
	)

	# When installing ncurses, we have to use a compatible version of tic.
	# This comes up when cross-compiling, doing multilib builds, upgrading,
	# or installing for the first time.  Build a local copy of tic whenever
	# the host version isn't available. #249363 #557598
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

		# Disabled until #245417 is sorted out.
		#$(use_with berkdb hashed-db)

		# Enable installation of .pc files.
		--enable-pc-files
		# This path is used to control where the .pc files are installed.
		--with-pkg-config-libdir="${EPREFIX}/usr/$(get_libdir)/pkgconfig"

		# Now the rest of the various standard flags.
		--with-shared
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

	# Force bash until upstream rebuilds the configure script with a newer
	# version of autotools. #545532
	#CONFIG_SHELL=${EPREFIX}/bin/bash \
	ECONF_SOURCE="${S}" \
	econf "${conf[@]}" "$@"
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
	# don't delete '*.dll.a', needed for linking #631468
	if ! use static-libs; then
		find "${ED}"/usr/ -name '*.a' ! -name '*.dll.a' -delete || die
	fi

	# Build fails to create this ...
	# -FIXME-
	# Ugly hackaround for riscv having two parts libdir (#689240)
	# Replace this hack with an official solution once we have one...
	# -FIXME-
	dosym $(sed 's@[^/]\+@..@g' <<< $(get_libdir))/share/terminfo \
		/usr/$(get_libdir)/terminfo
}

multilib_src_install_all() {
#	if ! use berkdb ; then
		# We need the basic terminfo files in /etc for embedded/recovery. #37026
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
#	fi

	echo "CONFIG_PROTECT_MASK=\"/etc/terminfo\"" | newenvd - 50ncurses

	use minimal && rm -r "${ED}"/usr/share/terminfo*
	# Because ncurses5-config --terminfo returns the directory we keep it
	keepdir /usr/share/terminfo #245374

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
