# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	ESVN_REPO_URI="https://svn.code.sf.net/p/sdcc/code/trunk/sdcc"
	inherit subversion
	docs_compile() { return 0; }
else
	SRC_URI="mirror://sourceforge/sdcc/${PN}-src-${PV}.tar.bz2
		doc? ( mirror://sourceforge/sdcc/${PN}-doc-${PV}.tar.bz2 )"
	KEYWORDS="~amd64 ~x86"
	docs_compile() { return 1; }
fi

DESCRIPTION="Small device C compiler (for various microprocessors)"
HOMEPAGE="http://sdcc.sourceforge.net/"

LICENSE="
	GPL-2 ZLIB
	non-free? ( MicroChip-SDCC )
	packihx? ( public-domain )
"
SLOT="0"
SDCC_PORTS="
	avr ds390 ds400 gbz80 hc08 mcs51 pic14 pic16 r2k r3ka s08 stm8 tlcs90 z180
	z80
"
IUSE="
	${SDCC_PORTS}
	+boehm-gc device-lib doc non-free packihx sdbinutils sdcdb +sdcpp ucsim
"

REQUIRED_USE="
	ds390? ( sdbinutils )
	ds400? ( sdbinutils )
	hc08?  ( sdbinutils )
	mcs51? ( sdbinutils )
	s08?   ( sdbinutils )
	|| ( ${SDCC_PORTS} )
"

RESTRICT="strip"

RDEPEND="
	dev-libs/boost:=
	sys-libs/ncurses:=
	sys-libs/readline:0=
	>=dev-embedded/gputils-0.13.7
	boehm-gc? ( dev-libs/boehm-gc:= )
	!dev-embedded/sdcc-svn
"
DEPEND="
	${RDEPEND}
	dev-util/gperf
"
if docs_compile ; then
DEPEND+="
	doc? (
		>=app-office/lyx-1.3.4
		dev-tex/latex2html
	)
"
fi

src_prepare() {
	# Fix conflicting variable names between Gentoo and sdcc
	find \
		'(' -name 'Makefile*.in' -o -name 'configure' ')' \
		-exec sed -r -i \
			-e 's:\<(PORTDIR|ARCH)\>:SDCC\1:g' \
			{} + || die

	# https://sourceforge.net/p/sdcc/bugs/2398/
	sed -i -e '1iAR = @AR@' Makefile.common.in || die
	sed -i \
		-e "/^AR =/s:=.*:=$(tc-getAR):" \
		support/cpp/Makefile.in || die

	# Make sure timestamps don't get messed up.
	[[ ${PV} == "9999" ]] && find "${S}" -type f -exec touch -r . {} +

	default
}

src_configure() {
	# sdbinutils subdir doesn't pass down --docdir properly, so need to
	# expand $(datarootdir) ourselves.
	econf \
		ac_cv_prog_STRIP=true \
		ac_cv_prog_AS="$(tc-getAS)" \
		ac_cv_prog_AR="$(tc-getAR)" \
		$(docs_compile && use_enable doc || echo --disable-doc) \
		$(use_enable avr avr-port) \
		$(use_enable boehm-gc libgc) \
		$(use_enable device-lib) \
		$(use_enable ds390 ds390-port) \
		$(use_enable ds400 ds400-port) \
		$(use_enable gbz80 gbz80-port) \
		$(use_enable hc08 hc08-port) \
		$(use_enable mcs51 mcs51-port) \
		$(use_enable non-free) \
		$(use_enable packihx) \
		$(use_enable pic14 pic14-port) \
		$(use_enable pic16 pic16-port) \
		$(use_enable r2k r2k-port) \
		$(use_enable r3ka r3ka-port) \
		$(use_enable s08 s08-port) \
		$(use_enable sdbinutils) \
		$(use_enable sdcdb) \
		$(use_enable sdcpp) \
		$(use_enable stm8 stm8-port) \
		$(use_enable tlcs90 tlcs90-port) \
		$(use_enable ucsim) \
		$(use_enable z180 z180-port) \
		$(use_enable z80 z80-port) \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--without-ccache
}

src_install() {
	default
	dodoc doc/*.txt
	find "${D}" -name .deps -exec rm -rf {} + || die

	if use doc ; then
		docs_compile || cd "${WORKDIR}"/doc
		docinto html
		doins -r *
	fi

	# a bunch of archives (*.a) are built & installed by gputils
	# for PIC processors, but they do not work with standard `ar`
	# & `scanelf` utils and they're not for the host.
	env RESTRICT="" prepstrip "${D%/}"/usr/bin
}
