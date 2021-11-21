# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	ESVN_REPO_URI="https://svn.code.sf.net/p/sdcc/code/trunk/sdcc"
	inherit subversion
else
	SRC_URI="
		mirror://sourceforge/sdcc/${PN}-src-${PV}.tar.bz2
		doc? ( mirror://sourceforge/sdcc/${PN}-doc-${PV}.tar.bz2 )
	"
	S="${WORKDIR}/sdcc"

	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Small device C compiler (for various microprocessors)"
HOMEPAGE="http://sdcc.sourceforge.net/"

LICENSE="
	GPL-2 ZLIB
	non-free? ( MicroChip-SDCC )
	packihx? ( public-domain )
"
SLOT="0"
# in order of configure.ac's AC_DO_PORT stanzas
SDCC_PORTS="
	avr
	mcs51
	z80 z180
	r2k r2ka r3ka
	gbz80
	tlcs90
	ez80-z80
	z80n
	ds390 ds400
	pic14 pic16
	hc08
	s08
	stm8
	pdk13 pdk14 pdk15 pdk16
"
IUSE="
	${SDCC_PORTS}
	+boehm-gc device-lib doc non-free packihx +sdbinutils sdcdb +sdcpp ucsim
"

for port in ${SDCC_PORTS}; do
REQUIRED_USE="${REQUIRED_USE}
	${port}? ( sdbinutils )
"
done
REQUIRED_USE="${REQUIRED_USE}
	|| ( ${SDCC_PORTS} )
"

RESTRICT="strip"

RDEPEND="
	dev-libs/boost:=
	sys-libs/ncurses:=
	sys-libs/readline:0=
	pic14? ( >=dev-embedded/gputils-0.13.7 )
	pic16? ( >=dev-embedded/gputils-0.13.7 )
	boehm-gc? ( dev-libs/boehm-gc:= )
	!dev-embedded/sdcc-svn
"
DEPEND="
	${RDEPEND}
	dev-util/gperf
"
PATCHES=(
	"${FILESDIR}"/${PN}-3.8.0-override-override.patch
)

src_prepare() {
	# Fix conflicting variable names between Gentoo and sdcc
	find \
		'(' -name 'Makefile*.in' -o -name 'configure' ')' \
		-exec sed -r -i \
			-e 's:\<(PORTDIR|ARCH)\>:SDCC\1:g' \
			{} + || die

	# Make sure timestamps don't get messed up.
	[[ ${PV} == "9999" ]] && find "${S}" -type f -exec touch -r . {} +

	default
	eautoreconf

	# Avoid 'bfd.info' rebuild with 'makeinfo': bug #705424
	# Build dependencies are: eautoreconf->Makefile.in->bfdver.texi->bfd.info
	touch support/sdbinutils/bfd/doc/bfdver.texi || die
	touch support/sdbinutils/bfd/doc/bfd.info || die
}

src_configure() {
	# sdbinutils subdir doesn't pass down --docdir properly, so need to
	# expand $(datarootdir) ourselves.
	econf \
		ac_cv_prog_AR="$(tc-getAR)" \
		ac_cv_prog_AS="$(tc-getAS)" \
		ac_cv_prog_STRIP=true \
		$(use_enable boehm-gc libgc) \
		$(use_enable device-lib) \
		$(use_enable non-free) \
		$(use_enable packihx) \
		$(use_enable sdbinutils) \
		$(use_enable sdcdb) \
		$(use_enable sdcpp) \
		$(use_enable ucsim) \
		\
		$(use_enable avr avr-port) \
		$(use_enable mcs51 mcs51-port) \
		$(use_enable z80 z80-port) \
		$(use_enable z180 z180-port) \
		$(use_enable r2k r2k-port) \
		$(use_enable r2ka r2ka-port) \
		$(use_enable r3ka r3ka-port) \
		$(use_enable gbz80 gbz80-port) \
		$(use_enable tlcs90 tlcs90-port) \
		$(use_enable ez80-z80 ez80_z80-port) \
		$(use_enable z80n z80n-port) \
		$(use_enable ds390 ds390-port) \
		$(use_enable ds400 ds400-port) \
		$(use_enable pic14 pic14-port) \
		$(use_enable pic16 pic16-port) \
		$(use_enable hc08 hc08-port) \
		$(use_enable s08 s08-port) \
		$(use_enable stm8 stm8-port) \
		$(use_enable pdk13 pdk13-port) \
		$(use_enable pdk14 pdk14-port) \
		$(use_enable pdk15 pdk15-port) \
		$(use_enable pdk16 pdk16-port) \
		\
		--disable-doc \
		--without-ccache
}

src_install() {
	default
	dodoc doc/*.txt
	find "${D}" -name .deps -exec rm -rf {} + || die

	if use doc && [[ ${PV} != "9999" ]]; then
		cd "${WORKDIR}"/doc
		dodoc -r *
	fi

	# a bunch of archives (*.a) are built & installed by gputils
	# for PIC processors, but they do not work with standard `ar`
	# & `scanelf` utils and they're not for the host.
	dostrip -x /usr/bin
}
