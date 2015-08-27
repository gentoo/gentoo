# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils flag-o-matic toolchain-funcs multilib-minimal

MY_PV=${PV:0:3}
PV_SNAP=${PV:4}
MY_P=${PN}-${MY_PV}
DESCRIPTION="console display library"
HOMEPAGE="https://www.gnu.org/software/ncurses/ http://dickey.his.com/ncurses/"
SRC_URI="mirror://gnu/ncurses/${MY_P}.tar.gz"

LICENSE="MIT"
# The subslot reflects the SONAME.
SLOT="0/5"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="ada +cxx debug doc gpm minimal profile static-libs tinfo trace unicode"

DEPEND="gpm? ( sys-libs/gpm )"
#	berkdb? ( sys-libs/db )"
# Block the older ncurses that installed all files w/SLOT=5. #557472
RDEPEND="${DEPEND}
	!<=sys-libs/ncurses-5.9-r4:5
	!<x11-terms/rxvt-unicode-9.06-r3
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20130224-r12
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
# Put the MULTILIB_USEDEP on gpm in PDEPEND only to avoid circular deps.
# We can move it to DEPEND and drop the --with-gpm=libgpm.so.1 from the econf
# line below once we can assume multilib gpm is available everywhere.
PDEPEND="gpm? ( sys-libs/gpm[${MULTILIB_USEDEP}] )"

S=${WORKDIR}/${MY_P}
HOSTTIC_DIR=${WORKDIR}/${P}-host

src_prepare() {
	[[ -n ${PV_SNAP} ]] && epatch "${WORKDIR}"/${MY_P}-${PV_SNAP}-patch.sh
	epatch "${FILESDIR}"/${PN}-5.8-gfbsd.patch
	epatch "${FILESDIR}"/${PN}-5.7-nongnu.patch
	epatch "${FILESDIR}"/${PN}-5.9-rxvt-unicode-9.15.patch #192083 #383871
	epatch "${FILESDIR}"/${PN}-5.9-fix-clang-build.patch #417763
	epatch "${FILESDIR}"/${PN}-5.9-pkg-config.patch
	epatch "${FILESDIR}"/${P}-no-I-usr-include.patch #522586
	epatch "${FILESDIR}"/${P}-gcc-5.patch #545114
}

src_configure() {
	unset TERMINFO #115036
	tc-export_build_env BUILD_{CC,CPP}
	BUILD_CPPFLAGS+=" -D_GNU_SOURCE" #214642

	# when cross-compiling, we need to build up our own tic
	# because people often don't keep matching host/target
	# ncurses versions #249363
	if tc-is-cross-compiler && ! ROOT=/ has_version ~sys-libs/${P} ; then
		CHOST=${CBUILD} \
		CFLAGS=${BUILD_CFLAGS} \
		CXXFLAGS=${BUILD_CXXFLAGS} \
		CPPFLAGS=${BUILD_CPPFLAGS} \
		LDFLAGS="${BUILD_LDFLAGS} -static" \
		BUILD_DIR="${HOSTTIC_DIR}" do_configure cross --without-shared --with-normal
	fi
	multilib-minimal_src_configure
}

multilib_src_configure() {
	do_configure narrowc
	use unicode && do_configure widec --enable-widec --includedir="${EPREFIX}"/usr/include/ncursesw
}

do_configure() {
	ECONF_SOURCE=${S}

	mkdir "${BUILD_DIR}"-$1
	cd "${BUILD_DIR}"-$1 || die
	shift

	local conf=(
		# We need the basic terminfo files in /etc, bug #37026.  We will
		# add '--with-terminfo-dirs' and then populate /etc/terminfo in
		# src_install() ...
		--with-terminfo-dirs="${EPREFIX}/etc/terminfo:${EPREFIX}/usr/share/terminfo"

		# Disabled until #245417 is sorted out.
		#$(use_with berkdb hashed-db)

		# ncurses is dumb and doesn't install .pc files unless pkg-config
		# is also installed.  Force the tests to go our way.  Note that it
		# doesn't actually use pkg-config ... it just looks for set vars.
		--enable-pc-files
		--with-pkg-config="$(tc-getPKG_CONFIG)"
		# This path is used to control where the .pc files are installed.
		PKG_CONFIG_LIBDIR="${EPREFIX}/usr/$(get_libdir)/pkgconfig"

		# Now the rest of the various standard flags.
		--with-shared
		--without-hashed-db
		$(use_with ada)
		$(use_with cxx)
		$(use_with cxx cxx-binding)
		$(use_with debug)
		$(use_with profile)
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
		$(use_enable !ada warnings)
		$(use_with debug assertions)
		$(use_enable !debug leaks)
		$(use_with debug expanded)
		$(use_with !debug macros)
		$(use_with trace)
		$(use_with tinfo termlib)

		# The chtype/mmask-t settings below are to retain ABI compat
		# with ncurses-5.4 so dont change em !
		--with-chtype=long
		--with-mmask-t=long
		--disable-ext-colors
		--disable-ext-mouse
		--without-pthread
		--without-reentrant
	)

	# Force bash until upstream rebuilds the configure script with a newer
	# version of autotools. #545532
	CONFIG_SHELL=/bin/bash econf "${conf[@]}" "$@"
}

src_compile() {
	# when cross-compiling, we need to build up our own tic
	# because people often don't keep matching host/target
	# ncurses versions #249363
	if tc-is-cross-compiler && ! ROOT=/ has_version ~sys-libs/${P} ; then
		make_flags="-C progs tic"
		BUILD_DIR="${HOSTTIC_DIR}" do_compile cross
	fi

	multilib-minimal_src_compile
}

multilib_src_compile() {
	make_flags=""
	multilib_is_native_abi || make_flags="PROGS= "
	do_compile narrowc
	use unicode && do_compile widec
}

do_compile() {
	cd "${BUILD_DIR}"-$1 || die

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
	rm -f misc/pc-files
	emake ${make_flags}
}

multilib_src_install() {
	# use the cross-compiled tic (if need be) #249363
	export PATH="${HOSTTIC_DIR}-cross/progs:${PATH}"

	# install unicode version second so that the binaries in /usr/bin
	# support both wide and narrow
	cd "${BUILD_DIR}"-narrowc || die
	emake DESTDIR="${D}" install
	if use unicode ; then
		cd "${BUILD_DIR}"-widec || die
		emake DESTDIR="${D}" install
	fi

	# Move libncurses{,w} into /lib
	multilib_is_native_abi && gen_usr_ldscript -a \
		ncurses \
		$(usex unicode 'ncursesw' '') \
		$(use tinfo && usex unicode 'tinfow' '') \
		$(usev tinfo)
	if ! tc-is-static-only ; then
		ln -sf libncurses$(get_libname) "${ED}"/usr/$(get_libdir)/libcurses$(get_libname) || die
	fi
	use static-libs || find "${ED}"/usr/ -name '*.a' -a '!' -name '*curses++*.a' -delete

	# Build fails to create this ...
	dosym ../share/terminfo /usr/$(get_libdir)/terminfo
}

multilib_src_install_all() {
#	if ! use berkdb ; then
		# We need the basic terminfo files in /etc, bug #37026
		einfo "Installing basic terminfo files in /etc..."
		for x in ansi console dumb linux rxvt rxvt-unicode screen sun vt{52,100,102,200,220} \
				 xterm xterm-color xterm-xfree86
		do
			local termfile=$(find "${ED}"/usr/share/terminfo/ -name "${x}" 2>/dev/null)
			local basedir=$(basename $(dirname "${termfile}"))

			if [[ -n ${termfile} ]] ; then
				dodir /etc/terminfo/${basedir}
				mv ${termfile} "${ED}"/etc/terminfo/${basedir}/
				dosym ../../../../etc/terminfo/${basedir}/${x} \
					/usr/share/terminfo/${basedir}/${x}
			fi
		done
#	fi

	echo "CONFIG_PROTECT_MASK=\"/etc/terminfo\"" > "${T}"/50ncurses
	doenvd "${T}"/50ncurses

	use minimal && rm -r "${ED}"/usr/share/terminfo*
	# Because ncurses5-config --terminfo returns the directory we keep it
	keepdir /usr/share/terminfo #245374

	cd "${S}"
	dodoc ANNOUNCE MANIFEST NEWS README* TO-DO doc/*.doc
	use doc && dohtml -r doc/html/
}
