# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://review.coreboot.org/flashrom.git"
	inherit git-r3
else
	MY_P="${PN}-v${PV}"
	SRC_URI="https://download.flashrom.org/releases/${MY_P}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Utility for reading, writing, erasing and verifying flash ROM chips"
HOMEPAGE="https://flashrom.org/Flashrom"

LICENSE="GPL-2"
SLOT="0"

# The defaults match the upstream meson_options.txt.
IUSE_PROGRAMMERS="
	atahpt
	atapromise
	+atavia
	+buspirate-spi
	+ch341a-spi
	+dediprog
	+developerbox-spi
	+digilent-spi
	+drkaiser
	+dummy
	+ft2232-spi
	+gfxnvidia
	+internal
	+it8212
	jlink-spi
	+linux-mtd
	+linux-spi
	lspcon-i2c-spi
	mstarddc-spi
	+nic3com
	+nicintel
	+nicintel-eeprom
	+nicintel-spi
	nicnatsemi
	+nicrealtek
	+ogp-spi
	+pickit2-spi
	+pony-spi
	+raiden-debug-spi
	+rayer-spi
	realtek-mst-i2c-spi
	+satamv
	+satasii
	+serprog
	+stlinkv3-spi
	+usbblaster-spi
"
IUSE="${IUSE_PROGRAMMERS} +internal-dmi test tools +wiki"

RESTRICT="!test? ( test )"

LIB_DEPEND="
	atahpt? ( sys-apps/pciutils[static-libs(+)] )
	atapromise? ( sys-apps/pciutils[static-libs(+)] )
	atavia? ( sys-apps/pciutils[static-libs(+)] )
	ch341a-spi? ( virtual/libusb:1[static-libs(+)] )
	dediprog? ( virtual/libusb:1[static-libs(+)] )
	developerbox-spi? ( virtual/libusb:1[static-libs(+)] )
	digilent-spi? ( virtual/libusb:1[static-libs(+)] )
	drkaiser? ( sys-apps/pciutils[static-libs(+)] )
	ft2232-spi? ( dev-embedded/libftdi:1=[static-libs(+)] )
	gfxnvidia? ( sys-apps/pciutils[static-libs(+)] )
	internal? ( sys-apps/pciutils[static-libs(+)] )
	it8212? ( sys-apps/pciutils[static-libs(+)] )
	jlink-spi? ( dev-embedded/libjaylink[static-libs(+)] )
	nic3com? ( sys-apps/pciutils[static-libs(+)] )
	nicintel-eeprom? ( sys-apps/pciutils[static-libs(+)] )
	nicintel-spi? ( sys-apps/pciutils[static-libs(+)] )
	nicintel? ( sys-apps/pciutils[static-libs(+)] )
	nicnatsemi? ( sys-apps/pciutils[static-libs(+)] )
	nicrealtek? ( sys-apps/pciutils[static-libs(+)] )
	ogp-spi? ( sys-apps/pciutils[static-libs(+)] )
	pickit2-spi? ( virtual/libusb:0[static-libs(+)] )
	raiden-debug-spi? ( virtual/libusb:0[static-libs(+)] )
	rayer-spi? ( sys-apps/pciutils[static-libs(+)] )
	satamv? ( sys-apps/pciutils[static-libs(+)] )
	satasii? ( sys-apps/pciutils[static-libs(+)] )
	stlinkv3-spi? ( virtual/libusb:1[static-libs(+)] )
	usbblaster-spi? ( dev-embedded/libftdi:1=[static-libs(+)] )
"
RDEPEND="${LIB_DEPEND//\[static-libs(+)]}"
DEPEND="${RDEPEND}
	sys-apps/diffutils"
RDEPEND+=" !internal-dmi? ( sys-apps/dmidecode )"
BDEPEND="test? ( dev-util/cmocka )"

DOCS=( README Documentation/ )

PATCHES=(
	"${FILESDIR}"/${PN}-9999_meson-fixes.patch
)

src_configure() {
	local emesonargs=(
		$(meson_use test build_tests)
		$(meson_use atahpt config_atahpt)
		$(meson_use atapromise config_atapromise)
		$(meson_use atavia config_atavia)
		$(meson_use buspirate-spi config_buspirate_spi)
		$(meson_use ch341a-spi config_ch341a_spi)
		$(meson_use dediprog config_dediprog)
		$(meson_use developerbox-spi config_developerbox_spi)
		$(meson_use digilent-spi config_digilent_spi)
		$(meson_use drkaiser config_drkaiser)
		$(meson_use dummy config_dummy)
		$(meson_use ft2232-spi config_ft2232_spi)
		$(meson_use gfxnvidia config_gfxnvidia)
		$(meson_use internal config_internal)
		$(meson_use internal-dmi config_internal_dmi)
		$(meson_use it8212 config_it8212)
		$(meson_use jlink-spi config_jlink_spi)
		$(meson_use linux-mtd config_linux_mtd)
		$(meson_use linux-spi config_linux_spi)
		$(meson_use lspcon-i2c-spi config_lspcon_i2c_spi)
		$(meson_use mstarddc-spi config_mstarddc_spi)
		$(meson_use nic3com config_nic3com)
		$(meson_use nicintel-eeprom config_nicintel_eeprom)
		$(meson_use nicintel-spi config_nicintel_spi)
		$(meson_use nicintel config_nicintel)
		$(meson_use nicnatsemi config_nicnatsemi)
		$(meson_use nicrealtek config_nicrealtek)
		$(meson_use ogp-spi config_ogp_spi)
		$(meson_use pickit2-spi config_pickit2_spi)
		$(meson_use pony-spi config_pony_spi)
		$(meson_use raiden-debug-spi config_raiden_debug_spi)
		$(meson_use rayer-spi config_rayer_spi)
		$(meson_use realtek-mst-i2c-spi config_realtek_mst_i2c_spi)
		$(meson_use satamv config_satamv)
		$(meson_use satasii config_satasii)
		$(meson_use stlinkv3-spi config_stlinkv3_spi)
		$(meson_use serprog config_serprog)
		$(meson_use usbblaster-spi config_usbblaster_spi)
		$(meson_use wiki print_wiki)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	if use tools; then
		dosbin "${BUILD_DIR}"/util/ich_descriptors_tool/ich_descriptors_tool
	fi
}
