# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson bash-completion-r1

DESCRIPTION="Utility for reading, writing, erasing and verifying flash ROM chips"
HOMEPAGE="https://www.flashrom.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

# The defaults should match the upstream "default" flags in meson.build
IUSE_PROGRAMMERS="
	+asm106x
	atahpt
	atapromise
	+atavia
	+buspirate-spi
	+ch341a-spi
	+ch347-spi
	+dediprog
	+developerbox-spi
	+digilent-spi
	+dirtyjtag-spi
	+drkaiser
	+dummy
	+ft2232-spi
	+gfxnvidia
	+internal
	+it8212
	+jlink-spi
	+linux-mtd
	+linux-spi
	parade-lspcon
	mediatek-i2c-spi
	mstarddc-spi
	ni845x-spi
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
	+spidriver
	+stlinkv3-spi
	+usbblaster-spi"
IUSE="${IUSE_PROGRAMMERS} +internal-dmi test tools"

RESTRICT="!test? ( test )"

COMMON="atahpt? ( sys-apps/pciutils )
	atapromise? ( sys-apps/pciutils )
	atavia? ( sys-apps/pciutils )
	ch341a-spi? ( virtual/libusb:1 )
	dediprog? ( virtual/libusb:1 )
	developerbox-spi? ( virtual/libusb:1 )
	digilent-spi? ( virtual/libusb:1 )
	dirtyjtag-spi? ( virtual/libusb:1 )
	drkaiser? ( sys-apps/pciutils )
	ft2232-spi? ( dev-embedded/libftdi:1= )
	gfxnvidia? ( sys-apps/pciutils )
	internal? ( sys-apps/pciutils )
	it8212? ( sys-apps/pciutils )
	jlink-spi? ( dev-embedded/libjaylink )
	nic3com? ( sys-apps/pciutils )
	nicintel? ( sys-apps/pciutils )
	nicintel-eeprom? ( sys-apps/pciutils )
	nicintel-spi? ( sys-apps/pciutils )
	nicnatsemi? ( sys-apps/pciutils )
	nicrealtek? ( sys-apps/pciutils )
	ogp-spi? ( sys-apps/pciutils )
	pickit2-spi? ( virtual/libusb:1 )
	raiden-debug-spi? ( virtual/libusb:1 )
	satamv? ( sys-apps/pciutils )
	satasii? ( sys-apps/pciutils )
	stlinkv3-spi? ( virtual/libusb:1 )
	usbblaster-spi? ( dev-embedded/libftdi:1= )"
RDEPEND="${COMMON}
	!internal-dmi? ( sys-apps/dmidecode )"
DEPEND="${COMMON}
	sys-apps/diffutils
	linux-mtd? ( sys-kernel/linux-headers )
	linux-spi? ( sys-kernel/linux-headers )
	mediatek-i2c-spi? ( sys-kernel/linux-headers )
	mstarddc-spi? ( sys-kernel/linux-headers )
	parade-lspcon? ( sys-kernel/linux-headers )
	realtek-mst-i2c-spi? ( sys-kernel/linux-headers )"
BDEPEND="test? ( dev-util/cmocka )"

DOCS=( README.rst doc/ )

src_configure() {
	local programmers="$(printf '%s,' $(for flag in ${IUSE_PROGRAMMERS//+/}; do usev ${flag}; done))"
	programmers="${programmers%,}"
	programmers="${programmers//-/_}"
	local emesonargs=(
		-Dclassic_cli="enabled"
		-Dprogrammer="${programmers}"
		-Dman-pages="disabled"
		-Ddocumentation="disabled"
		$(meson_feature test tests)
		$(meson_feature tools ich_descriptors_tool)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	# Upstream requires libflashrom.a to be present at build time
	# because the classic CLI executable uses internal symbols from that
	# library.  Therefore, we let it be built but keep it out of the
	# installed tree.
	find "${ED}" -name '*.a' -delete || die

	# bash completion file is not up to standards, #941844
	rm -Rf "${ED}"/usr/share/bash-completion
	newbashcomp "${BUILD_DIR}/${PN}.bash" "${PN}"

	if use tools; then
		dosbin "${BUILD_DIR}"/util/ich_descriptors_tool/ich_descriptors_tool
	fi
}
