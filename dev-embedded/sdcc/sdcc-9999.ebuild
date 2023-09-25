# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

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

DESCRIPTION="Small device C compiler (for various microprocessors)"
HOMEPAGE="https://sdcc.sourceforge.net/"

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
	z80n
	ds390 ds400
	pic14 pic16
	hc08
	s08
	stm8
	pdk13 pdk14 pdk15 pdk16
	mos6502 mos65c02
"
IUSE="
	${SDCC_PORTS}
	+boehm-gc device-lib doc non-free packihx sdcdb +sdcpp ucsim
"

RDEPEND="
	dev-libs/boost:=
	sys-libs/zlib:=
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
)

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

	default
	eautoreconf

	# Avoid 'bfd.info' rebuild with 'makeinfo': bug #705424
	# Build dependencies are: eautoreconf->Makefile.in->bfdver.texi->bfd.info
	touch support/sdbinutils/bfd/doc/bfdver.texi || die
	touch support/sdbinutils/bfd/doc/bfd.info || die
}

src_configure() {
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
	)
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

	if use doc && [[ ${PV} != "9999" ]]; then
		cd "${WORKDIR}"/doc
		dodoc -r *
	fi
}
