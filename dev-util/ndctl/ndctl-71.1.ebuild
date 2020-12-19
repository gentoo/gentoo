# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools bash-completion-r1 linux-info systemd

DESCRIPTION="Utility library for managing the libnvdimm sub-system in the Linux kernel"

HOMEPAGE="https://pmem.io/"
SRC_URI="https://github.com/pmem/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-2.1"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# All the tests, like the rest of the nvdimm subsystem, require root to run
# Futhermore, the tests require special testing kernel modules
# However, the "ndctl test" command can be used to run some of the test
# After is it installed
RESTRICT="test"

RDEPEND="dev-libs/json-c
	sys-apps/keyutils
	sys-apps/kmod
	virtual/udev"
DEPEND="${RDEPEND}"
BDEPEND="app-text/asciidoc
	 app-text/xmlto
	 virtual/pkgconfig"

CONFIG_CHECK="~ZONE_DEVICE ~MEMORY_HOTPLUG ~MEMORY_HOTREMOVE
~TRANSPARENT_HUGEPAGE ~ACPI_NFIT ~X86_PMEM_LEGACY ~OF_PMEM ~LIBNVDIMM
~BLK_DEV_PMEM ~BTT ~NVDIMM_PFN ~NVDIMM_DAX ~FS_DAX ~DAX ~DEV_DAX
~DEV_DAX_PMEM ~DEV_DAX_KMEM"

src_prepare() {
	default
	[[ -f "${S}/version" ]] || echo "${PV}" > "${S}/version"
	"${S}"/git-version-gen
	eautoreconf
}

src_configure() {
	econf \
	  --enable-test \
	  --disable-asciidoctor \
	  --without-bash \
	  --without-systemd \
	  --with-keyutils
}

src_install() {
	default
	dobashcomp contrib/${PN}
	systemd_dounit ${PN}/ndctl-monitor.service
	find "${D}" -name '*.la' -delete || die
}
