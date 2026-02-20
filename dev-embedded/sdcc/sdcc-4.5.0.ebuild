# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Small device C compiler (for various microprocessors)"
HOMEPAGE="https://sdcc.sourceforge.net/"

if [[ ${PV} == "9999" ]] ; then
	ESVN_REPO_URI="https://svn.code.sf.net/p/sdcc/code/trunk/sdcc"
	inherit subversion
else
	SRC_URI="
		https://downloads.sourceforge.net/project/${PN}/sdcc/${PV}/${PN}-src-${PV}.tar.bz2
		doc? ( https://downloads.sourceforge.net/project/${PN}/sdcc-doc/${PV}/${PN}-doc-${PV}.tar.bz2 )
	"

	KEYWORDS="~amd64 ~x86"
fi
BINUTILS_PV=2.45.1
SRC_URI+="
	mirror://gnu/binutils/binutils-${BINUTILS_PV}.tar.xz
	https://sourceware.org/pub/binutils/releases/binutils-${BINUTILS_PV}.tar.xz
"

LICENSE="
	GPL-2 ZLIB
	non-free? ( MicroChip-SDCC )
	packihx? ( public-domain )
"
SLOT="0"
# in order of configure.ac's AC_DO_PORT stanzas
SDCC_PORTS="
	mcs51
	z80 z180
	r2k r2ka r3ka
	sm83
	tlcs90
	ez80-z80
	z80n r800
	ds390 ds400
	pic14 pic16
	hc08
	s08
	stm8
	pdk13 pdk14 pdk15 pdk16
	mos6502 mos65c02
	f8
"
IUSE="
	${SDCC_PORTS}
	+boehm-gc device-lib doc non-free packihx sdcdb +sdcpp ucsim
"

RDEPEND="
	dev-libs/boost:=
	virtual/zlib:=
	pic14? ( >=dev-embedded/gputils-0.13.7 )
	pic16? ( >=dev-embedded/gputils-0.13.7 )
	boehm-gc? ( dev-libs/boehm-gc:= )
	sdcdb? ( sys-libs/readline:0= )
	ucsim? ( sys-libs/ncurses:= )
"
DEPEND="
	${RDEPEND}
	dev-util/gperf
"
PATCHES=(
	"${FILESDIR}"/sdcc-4.3.2-override-override.patch
	"${FILESDIR}"/sdcc-4.5.0-link-tinfo.patch
	"${FILESDIR}"/sdcc-4.3.0-fix-mkdir-autoconf-test.patch
	"${FILESDIR}"/sdcc-4.3.0-autoreconf-libiberty.patch
	"${FILESDIR}"/sdcc-4.3.0-fix-elf-type.patch
	"${FILESDIR}"/${P}-c23.patch
)

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		subversion_src_unpack
	fi
	default
}

src_prepare() {
	# Fix conflicting variable names between Gentoo and sdcc
	find device/lib/pic{14,16} device/non-free/lib/pic{14,16} \( \
			-name 'configure.ac' -o -name 'Makefile.*' \) \
		-exec sed -i 's/\<ARCH\>/SDCC_&/g' {} + || die
	find device -name 'Makefile.in' \
		-exec sed -i 's/\<PORTDIR\>/SDCC_&/g' {} + || die
	# Possible alternative: Patch the following files to not pick up the
	# variables from the environment:
	# - lib/Makefile.in (PORTDIR ifndef/endif)
	# - device/non-free/lib/pic14/Makefile.common.in (ARCH ?= 877)
	# - device/non-free/lib/pic16/configure.ac (${ARCH:-18f452})
	# - device/lib/pic14/configure.ac (${ARCH:-16f877})
	# - device/lib/pic16/configure.ac (${ARCH:-18f452})

	# Make sure timestamps don't get messed up.
	[[ ${PV} == "9999" ]] && find "${S}" -type f -exec touch -r . {} +

	mkdir -p support/sdbinutils/bfd/doc || die

	# add m4 files from binutils to run autoreconf for libiberty
	cp "${WORKDIR}"/binutils-${BINUTILS_PV}/libiberty/acinclude.m4 support/sdbinutils/libiberty/acinclude.m4 || die
	cp "${WORKDIR}"/binutils-${BINUTILS_PV}/config/mmap.m4 support/sdbinutils/config/mmap.m4 || die
	# libiberty configure will check this file and fail if not found
	cp install-sh support/sdbinutils/libiberty/ || die
	# libiberty configure will fail if this was not set
	export libiberty_topdir="${S}"/support/sdbinutils/libiberty

	default

	# Upstream moved sim/ucsim to sim/ucsim/src and added some wrappers in sim/ucsim.
	# Now eautoreconf needs to run in sim/ucsim/src, but configure needs to run in sim/ucsim.
	# Run eautoreconf manually where it is needed and leave econf do its thing.
	local dirs=(
			support/cpp
			support/packihx
			sim/ucsim/src
			debugger/mcs51
			support/sdbinutils
			support/sdbinutils/libiberty
			device/lib/pic14
			device/non-free/lib/pic14
			device/lib/pic16
			device/non-free/lib/pic16
		)
	for i in "${dirs[@]}"; do
		pushd "$i" &> /dev/null || die
		AT_NOELIBTOOLIZE=yes eautoreconf
		popd &> /dev/null || die
	done
	AT_NO_RECURSIVE=yes eautoreconf

	# Avoid 'bfd.info' rebuild with 'makeinfo': bug #705424
	# Build dependencies are: eautoreconf->Makefile.in->bfdver.texi->bfd.info
	touch support/sdbinutils/bfd/doc/bfdver.texi || die
	touch support/sdbinutils/bfd/doc/bfd.info || die
}

src_configure() {
	# bug #922301
	tc-export CC CPP
	local myeconfargs=(
		ac_cv_prog_STRIP=true
		--without-ccache
		--enable-sdbinutils

		$(use_enable ucsim)

		$(use_enable device-lib)
		$(use_enable packihx)
		$(use_enable sdcpp)
		$(use_enable sdcdb)
		$(use_enable non-free)
		$(use_enable boehm-gc libgc)

		$(use_enable mcs51 mcs51-port)
		$(use_enable z80 z80-port)
		$(use_enable z180 z180-port)
		$(use_enable r2k r2k-port)
		$(use_enable r2ka r2ka-port)
		$(use_enable r3ka r3ka-port)
		$(use_enable sm83 sm83-port)
		$(use_enable tlcs90 tlcs90-port)
		$(use_enable ez80-z80 ez80_z80-port)
		$(use_enable z80n z80n-port)
		$(use_enable r800 r800-port)
		$(use_enable ds390 ds390-port)
		$(use_enable ds400 ds400-port)
		$(use_enable pic14 pic14-port)
		$(use_enable pic16 pic16-port)
		$(use_enable hc08 hc08-port)
		$(use_enable s08 s08-port)
		$(use_enable stm8 stm8-port)
		$(use_enable pdk13 pdk13-port)
		$(use_enable pdk14 pdk14-port)
		$(use_enable pdk15 pdk15-port)
		$(use_enable pdk16 pdk16-port)
		$(use_enable mos6502 mos6502-port)
		$(use_enable mos65c02 mos65c02-port)
		$(use_enable f8 f8-port)
	)

	# ucsim has extra sims that do not correspond to USE flags; enable them all.
	if use ucsim; then
		myeconfargs+=( --enable-serio )
		for i in avr st7 p1516 m6809 m6800 m68hc11 m68hc12 pblaze i8085 i8048 oisc; do
			myeconfargs+=( --enable-$i-sim )
		done
	fi

	econf "${myeconfargs[@]}"
}

src_compile() {
	default

	# Sanity check, as gputils errors/segfaults don't cause make to stop
	local libs=()
	use pic14 && libs+=( device/lib/build/pic14/libsdcc.lib )
	use pic16 && libs+=( device/lib/build/pic16/libsdcc.lib )
	for lib in "${libs[@]}"; do
		[[ -f "${lib}" ]] || die "Failed to build ${lib}"
	done
}

src_install() {
	default
	dodoc doc/*.txt
	find "${ED}" -type d -name .deps -exec rm -vr {} + || die

	# make install does not install this
	use ucsim && dobin sim/ucsim/src/apps/serio.src/serialview

	if use doc && [[ ${PV} != "9999" ]]; then
		cd "${WORKDIR}"/doc
		dodoc -r *
	fi
}
