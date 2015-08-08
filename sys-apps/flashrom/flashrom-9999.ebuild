# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs
if [[ ${PV} == "9999" ]] ; then
	ESVN_REPO_URI="svn://flashrom.org/flashrom/trunk"
	inherit subversion
else
	SRC_URI="http://download.flashrom.org/releases/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~sparc ~x86"
fi

DESCRIPTION="Utility for reading, writing, erasing and verifying flash ROM chips"
HOMEPAGE="http://flashrom.org/"

LICENSE="GPL-2"
SLOT="0"
# The defaults match the upstream Makefile.
# Note: Do not list bitbang_spi as it is not a programmer; it's a backend used
# by some other spi programmers.
IUSE_PROGRAMMERS="atahpt +atavia +buspirate_spi dediprog +drkaiser +dummy
+ft2232_spi +gfxnvidia +internal +it8212 +linux_spi mstarddc_spi +nic3com
+nicintel +nicintel_eeprom +nicintel_spi nicnatsemi +nicrealtek +ogp_spi
+pickit2_spi +pony_spi +rayer_spi +satamv +satasii +serprog +usbblaster_spi"
IUSE="${IUSE_PROGRAMMERS} +internal_dmi static tools +wiki"

LIB_DEPEND="atahpt? ( sys-apps/pciutils[static-libs(+)] )
	atavia? ( sys-apps/pciutils[static-libs(+)] )
	dediprog? ( virtual/libusb:0[static-libs(+)] )
	drkaiser? ( sys-apps/pciutils[static-libs(+)] )
	ft2232_spi? ( dev-embedded/libftdi[static-libs(+)] )
	gfxnvidia? ( sys-apps/pciutils[static-libs(+)] )
	it8212? ( sys-apps/pciutils[static-libs(+)] )
	internal? ( sys-apps/pciutils[static-libs(+)] )
	nic3com? ( sys-apps/pciutils[static-libs(+)] )
	nicintel? ( sys-apps/pciutils[static-libs(+)] )
	nicintel_eeprom? ( sys-apps/pciutils[static-libs(+)] )
	nicintel_spi? ( sys-apps/pciutils[static-libs(+)] )
	nicnatsemi? ( sys-apps/pciutils[static-libs(+)] )
	nicrealtek? ( sys-apps/pciutils[static-libs(+)] )
	ogp_spi? ( sys-apps/pciutils[static-libs(+)] )
	pickit2_spi? ( virtual/libusb:0[static-libs(+)] )
	rayer_spi? ( sys-apps/pciutils[static-libs(+)] )
	satamv? ( sys-apps/pciutils[static-libs(+)] )
	satasii? ( sys-apps/pciutils[static-libs(+)] )
	usbblaster_spi? ( dev-embedded/libftdi[static-libs(+)] )"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )
	sys-apps/diffutils"
RDEPEND+=" !internal_dmi? ( sys-apps/dmidecode )"

_flashrom_enable() {
	local c="CONFIG_${2:-$(echo "$1" | tr [:lower:] [:upper:])}"
	args+=( "${c}=$(usex $1 yes no)" )
}
flashrom_enable() {
	local u
	for u ; do _flashrom_enable "${u}" ; done
}

src_prepare() {
	sed -i \
		-e 's:pkg-config:$(PKG_CONFIG):' \
		Makefile || die
}

src_compile() {
	# Help keep things in sync.
	local sprogs=$(echo $(
		grep -o 'CONFIG_[A-Z0-9_]*' flashrom.c | \
			sort -u | \
			sed 's:^CONFIG_::' | \
			tr '[:upper:]' '[:lower:]'))
	local eprogs=$(echo ${IUSE_PROGRAMMERS//[+-]})
	if [[ ${sprogs} != "${eprogs}" ]] ; then
		eerror "The ebuild needs to be kept in sync."
		eerror "IUSE set to: ${eprogs}"
		eerror "flashrom.c : ${sprogs}"
		die "sync IUSE to the list of source programmers"
	fi

	# Turn USE flags into CONFIG_xxx settings.
	local args=()
	flashrom_enable ${eprogs}
	_flashrom_enable wiki PRINT_WIKI
	_flashrom_enable static STATIC

	# You have to specify at least one programmer, and if you specify more than
	# one programmer you have to include either dummy or internal in the list.
	# We pick dummy as the default because internal requires libpci.
	if ! use internal && ! use dummy ; then
		if [[ ${#args[@]} -ne 1 ]] ; then
			ewarn "You have to specify at least one programmer, and if you specify"
			ewarn "more than one programmer, you have to enable either dummy or"
			ewarn "internal as well.  'dummy' will be the default now."
			args+=( CONFIG_DUMMY=yes )
		fi
	fi

	tc-export AR CC PKG_CONFIG RANLIB
	emake WARNERROR=no "${args[@]}"
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
	dodoc README Documentation/*.txt

	if use tools ; then
		if use amd64 ; then
			dosbin util/ich_descriptors_tool/ich_descriptors_tool
		elif use x86 ; then
			dosbin util/ich_descriptors_tool/ich_descriptors_tool
		fi
	fi
}
