# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils flag-o-matic toolchain-funcs multilib-minimal multiprocessing

MY_PV=${PV:0:3}
PV_SNAP=${PV:4}
MY_P=${PN}-${MY_PV}
DESCRIPTION="console display library"
HOMEPAGE="http://www.gnu.org/software/ncurses/ http://dickey.his.com/ncurses/"
SRC_URI="mirror://gnu/ncurses/${MY_P}.tar.gz"

LICENSE="MIT"
# TODO: We should migrate this to SLOT=0.
# The subslot reflects the SONAME.
SLOT="5/6"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="ada +cxx debug doc gpm minimal profile static-libs test tinfo trace unicode"

DEPEND="gpm? ( sys-libs/gpm[${MULTILIB_USEDEP}] )"
#	berkdb? ( sys-libs/db )"
RDEPEND="${DEPEND}
	!<x11-terms/rxvt-unicode-9.06-r3
	!app-emulation/emul-linux-x86-baselibs"

S=${WORKDIR}/${MY_P}
HOSTTIC_DIR=${WORKDIR}/${P}-host

PATCHES=(
	"${FILESDIR}/${PN}-6.0-gfbsd.patch"
	"${FILESDIR}/${PN}-5.7-nongnu.patch"
	"${FILESDIR}/${PN}-6.0-rxvt-unicode-9.15.patch" #192083 #383871
	"${FILESDIR}/${PN}-6.0-pkg-config.patch"
	"${FILESDIR}/${PN}-5.9-gcc-5.patch" #545114
)

src_prepare() {
	[[ -n ${PV_SNAP} ]] && epatch "${WORKDIR}"/${MY_P}-${PV_SNAP}-patch.sh
	epatch "${PATCHES[@]}"
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
	multijob_init
	multijob_child_init do_configure narrowc
	use unicode && multijob_child_init do_configure widec --enable-widec --includedir="${EPREFIX}"/usr/include/ncursesw
	multijob_finish
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
		BUILD_DIR="${HOSTTIC_DIR}" do_compile cross -C progs tic
	fi

	multilib-minimal_src_compile
}

multilib_src_compile() {
	do_compile narrowc
	use unicode && do_compile widec
}

do_compile() {
	cd "${BUILD_DIR}"-$1 || die
	shift

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
	emake "$@"
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
	use static-libs || find "${ED}"/usr/ -name '*.a' -delete

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

pkg_preinst() {
	preserve_old_lib /$(get_libdir)/libncurses.so.5
	use unicode && preserve_old_lib /$(get_libdir)/libncursesw.so.5
}

pkg_postinst() {
	preserve_old_lib_notify /$(get_libdir)/libncurses.so.5
	use unicode && preserve_old_lib_notify /$(get_libdir)/libncursesw.so.5
}
