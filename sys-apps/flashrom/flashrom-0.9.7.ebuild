# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs
if [[ ${PV} == "9999" ]] ; then
	ESVN_REPO_URI="svn://flashrom.org/flashrom/trunk"
	inherit subversion
else
	SRC_URI="http://download.flashrom.org/releases/${P}.tar.bz2"
	KEYWORDS="amd64 arm ~mips x86"
fi

DESCRIPTION="Utility for reading, writing, erasing and verifying flash ROM chips"
HOMEPAGE="http://flashrom.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="atahpt +bitbang_spi +buspirate_spi +dediprog +drkaiser
+dummy ft2232_spi +gfxnvidia +internal +linux_spi +nic3com +nicintel
+nicintel_spi nicnatsemi nicrealtek +ogp_spi rayer_spi
+pony_spi +satasii satamv +serprog static tools usbblaster +wiki"

LIB_DEPEND="atahpt? ( sys-apps/pciutils[static-libs(+)] )
	dediprog? ( virtual/libusb:0[static-libs(+)] )
	drkaiser? ( sys-apps/pciutils[static-libs(+)] )
	ft2232_spi? ( dev-embedded/libftdi[static-libs(+)] )
	gfxnvidia? ( sys-apps/pciutils[static-libs(+)] )
	internal? ( sys-apps/pciutils[static-libs(+)] )
	nic3com? ( sys-apps/pciutils[static-libs(+)] )
	nicintel? ( sys-apps/pciutils[static-libs(+)] )
	nicintel_spi? ( sys-apps/pciutils[static-libs(+)] )
	nicnatsemi? ( sys-apps/pciutils[static-libs(+)] )
	nicrealtek? ( sys-apps/pciutils[static-libs(+)] )
	rayer_spi? ( sys-apps/pciutils[static-libs(+)] )
	satasii? ( sys-apps/pciutils[static-libs(+)] )
	satamv? ( sys-apps/pciutils[static-libs(+)] )
	usbblaster? ( dev-embedded/libftdi[static-libs(+)] )
	ogp_spi? ( sys-apps/pciutils[static-libs(+)] )"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )
	sys-apps/diffutils"
RDEPEND+=" internal? ( sys-apps/dmidecode )"

_flashrom_enable() {
	local c="CONFIG_${2:-$(echo $1 | tr [:lower:] [:upper:])}"
	args+=" $c=$(usex $1 yes no)"
}
flashrom_enable() {
	local u
	for u in "$@" ; do _flashrom_enable $u ; done
}

src_compile() {
	local progs=0
	local args=""

	# Programmer
	flashrom_enable \
		atahpt bitbang_spi buspirate_spi dediprog drkaiser \
		ft2232_spi gfxnvidia linux_spi nic3com nicintel \
		nicintel_spi nicnatsemi nicrealtek ogp_spi rayer_spi \
		pony_spi satasii satamv serprog usbblaster \
		internal dummy
	_flashrom_enable wiki PRINT_WIKI
	_flashrom_enable static STATIC

	# You have to specify at least one programmer, and if you specify more than
	# one programmer you have to include either dummy or internal in the list.
	for prog in ${IUSE//[+-]} ; do
		case ${prog} in
			internal|dummy|wiki) continue ;;
		esac

		use ${prog} && : $(( progs++ ))
	done
	if [[ ${progs} -ne 1 ]] ; then
		if ! use internal && ! use dummy ; then
			ewarn "You have to specify at least one programmer, and if you specify"
			ewarn "more than one programmer, you have to enable either dummy or"
			ewarn "internal as well.  'internal' will be the default now."
			args+=" CONFIG_INTERNAL=yes"
		fi
	fi

	# WARNERROR=no, bug 347879
	tc-export AR CC RANLIB
	emake WARNERROR=no ${args}
}

src_test() {
	if [[ -d tests ]] ; then
		pushd tests >/dev/null
		./tests.py || die
		popd >/dev/null
	fi
}

src_install() {
	dosbin flashrom
	doman flashrom.8
	dodoc ChangeLog README Documentation/*.txt

	if use tools; then
		if use amd64; then
			dosbin util/ich_descriptors_tool/ich_descriptors_tool
		elif use x86; then
			dosbin util/ich_descriptors_tool/ich_descriptors_tool
		fi
	fi
}
