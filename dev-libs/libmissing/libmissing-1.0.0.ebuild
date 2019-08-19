# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

# NOTE: PV is the libtool version number current:revision:age

DESCRIPTION="Library with missing functions based on GNUlib"
HOMEPAGE="https://prefix.gentoo.org"
GIT_TAG="b451121ab45497e78cb6f612c8673a9705193391"
SRC_URI="https://git.savannah.gnu.org/cgit/gnulib.git/snapshot/gnulib-${GIT_TAG}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/gnulib-${GIT_TAG}"

src_prepare() {
	default

	mkdir "${PN}" || die
	cd "${PN}" || die
	cat > configure.ac <<- EOS
		AC_PREREQ([2.69])
		AC_INIT([${PN}], [${PV}], [prefix@gentoo.org])
		AM_INIT_AUTOMAKE
		LT_INIT

		AC_CONFIG_MACRO_DIR([m4])
		AC_CONFIG_HEADER([config.h])

		AC_PROG_CC
		gl_INIT
		gl_EARLY

		AC_CONFIG_FILES([Makefile lib/Makefile])

		AC_OUTPUT
	EOS

	cat > Makefile.am <<- EOS
		SUBDIRS = lib
	EOS

	local modules
	local platform
	local rev

	case "${CHOST}" in
		*-apple-darwin*)
			rev=${CHOST##*-darwin}
			platform="Mac OS X 10.$((rev - 4))"
			;;
		*-solaris2.*)
			rev=${CHOST##*-solaris2.}
			# we only support Solaris 10 (and perhaps 9) and up, so we
			# don't have to bother about 2.x, just X
			platform="Solaris ${rev}"
			;;
	esac

	# blacklist some modules that cause collisions
	# iconv      provided by virtual/iconv -> sys-libs/libiconv
	modules=( $(
		cd "${S}"/doc/posix-functions
		grep -A1 "This function is missing" *.texi | \
			grep "${platform}" | \
			sed -e 's:^\(.[^-]*\)-.*$:\1:' | \
			xargs sed -n 's/^Gnulib module: \([a-z].*\)$/\1/p' | \
			sed -e 's: or .*$::' -e 's:, :\n:g' | \
			sort -u | \
			grep -v "iconv"
	) )

	# get platform specific set of missing functions
	einfo "Including sources for missing functions on ${platform}:"
	einfo "${modules[*]}"
	"${S}"/gnulib-tool \
		--import \
		--lib=libmissing \
		--libtool \
		--no-vc-files \
		"${modules[@]}"

	sed -i -e '/^noinst_LTLIBRARIES /s/noinst_/lib_/' lib/Makefile.am || die
	echo "libmissing_la_LDFLAGS += version-info ${PV//./:}" >> lib/Makefile.am
	cat >> lib/Makefile.am << 'EOS'
install-data-local: $(BUILT_SOURCES)
	@for hdr in $(BUILT_SOURCES); do \
		$(mkinstalldirs) $(DESTDIR)$(includedir)/$${hdr%/*}; \
		$(INSTALL_HEADER) "$$hdr" $(DESTDIR)$(includedir)/$${hdr}; \
	done;
EOS

	eautoreconf
}

src_configure() {
	cd "${PN}" || die
	default
}

src_compile() {
	cd "${PN}" || die
	default
}

src_install() {
	cd "${PN}" || die
	default

	rm "${ED}"/usr/lib/libmissing.la \
		"$(use static-libs || echo "${ED}"/usr/lib/libmissing.a)" || die
}
