# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/sdcc/sdcc-3.5.0.ebuild,v 1.1 2015/07/12 14:39:54 perfinion Exp $

EAPI="5"

inherit eutils

SRC_URI="mirror://sourceforge/sdcc/${PN}-src-${PV}.tar.bz2"
DESCRIPTION="Small device C compiler (for various microprocessors)"
HOMEPAGE="http://sdcc.sourceforge.net/"

LICENSE="GPL-2 ZLIB
	non-free? ( MicroChip-SDCC )
	packihx? ( public-domain )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="mcs51 z80 z180 r2k r3ka gbz80 tlcs90 ds390 ds400 pic14 pic16 hc08 s08 stm8
ucsim device-lib packihx +sdcpp sdcdb sdbinutils non-free +boehm-gc"

REQUIRED_USE="mcs51? ( sdbinutils )
			ds390? ( sdbinutils )
			ds400? ( sdbinutils )
			hc08?  ( sdbinutils )
			s08?   ( sdbinutils )"

# ADD "binchecks" to fix the "scanelf: Invalid 'ar' entry" messages
# OR leave the overwrite of CTARGET in src_install()
RESTRICT="strip"

RDEPEND="dev-libs/boost:=
		dev-util/gperf
		sys-libs/ncurses:=
		sys-libs/readline:=
		dev-embedded/gputils
		boehm-gc? ( dev-libs/boehm-gc:= )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${PV}"

src_prepare()
{
	# Fix conflicting variable names between Gentoo and sdcc
	find \
		'(' -name 'Makefile*.in' -o -name 'configure' ')' \
		-exec sed -r -i \
		-e 's:\<(PORTDIR|ARCH)\>:SDCC\1:g' \
		{} + || die
}

src_configure()
{
	econf \
		--prefix="${EPREFIX}"/usr \
		--docdir="${EPREFIX}"/usr/share/doc/${P} \
		$(use_enable mcs51 mcs51-port) \
		$(use_enable z80 z80-port) \
		$(use_enable z180 z180-port) \
		$(use_enable r2k r2k-port) \
		$(use_enable r3ka r3ka-port) \
		$(use_enable gbz80 gbz80-port) \
		$(use_enable tlcs90 tlcs90-port) \
		$(use_enable ds390 ds390-port) \
		$(use_enable ds400 ds400-port) \
		$(use_enable pic14 pic14-port) \
		$(use_enable pic16 pic16-port) \
		$(use_enable hc08 hc08-port) \
		$(use_enable s08 s08-port) \
		$(use_enable stm8 stm8-port) \
		$(use_enable ucsim ucsim) \
		$(use_enable device-lib device-lib) \
		$(use_enable packihx packihx) \
		$(use_enable sdcpp sdcpp) \
		$(use_enable sdcdb sdcdb) \
		$(use_enable sdbinutils sdbinutils) \
		$(use_enable non-free non-free) \
		$(use_enable boehm-gc libgc)
}

src_install()
{
	emake DESTDIR="${D}" install

	dodoc doc/README.txt

	find "${D}" -name .deps -exec rm -rf {} + || die

	# See /usr/lib/portage/python${version}/install-qa-check.d/10executable-issues
	# Installed libs are not for our CHOST but for microcontrollers
	# This disable QA_EXECSTACK, QA_WX_LOAD and scanelf -qyRAF '%e %p'
	CTARGET="undefined"
}
