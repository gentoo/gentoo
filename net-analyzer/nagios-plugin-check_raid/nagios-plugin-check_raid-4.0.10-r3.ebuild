# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

#COMMIT=""
MY_PV="${COMMIT:-${PV}}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Nagios/Icinga plugin to check current server's RAID status"
HOMEPAGE="https://github.com/glensc/nagios-plugin-check_raid"
SRC_URI="https://github.com/glensc/nagios-plugin-check_raid/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="3ware aacraid dmraid hpa hpsa megaraid-sas mpt mpt-sas2"

DEPEND="
	dev-perl/Monitoring-Plugin
	dev-perl/Module-Pluggable"
RDEPEND="${DEPEND}
	sys-apps/smartmontools
	sys-fs/lsscsi
	3ware? ( sys-block/tw_cli )
	aacraid? ( sys-block/arcconf )
	dmraid? ( sys-fs/dmraid )
	hpa? ( sys-block/hpacucli )
	hpsa? ( sys-apps/cciss_vol_status )
	megaraid-sas? ( sys-block/megacli )
	mpt-sas2? ( sys-block/sas2ircu )
	mpt? ( sys-block/mpt-status )"

src_prepare() {
	default

	# Upstream has a custom Makefile that is meant to build bundles
	sed -i '/CPANfile/d' Makefile.PL || die
}

src_install() {
	default
	dodoc README.md CHANGELOG.md CONTRIBUTING.md check_raid.cfg

	local plugindir="/usr/$(get_libdir)/nagios/plugins"
	dodir "${plugindir}"
	mv -f "${ED}"/usr/bin/check_raid.pl "${ED}/${plugindir}" || die
}

pkg_postinst() {
	einfo "The following RAID controllers are supported without special tools:"
	einfo "GDT (Intel/ICP) RAID Controller"
	einfo "HP MSA (special configuration needed)"
	einfo "The following RAID controllers do not have tools packaged in Gentoo, but ARE supported by this tool:"
	einfo "Intel: CmdTool2"
	einfo "Areca: areca-cli"
	einfo "See https://github.com/glensc/nagios-plugin-check_raid/issues/10"
	einfo "Marvell RAID: mvcli"
	einfo "See https://github.com/glensc/nagios-plugin-check_raid/issues/92"
	einfo "Adaptec ServeRAID: aaccli"
	einfo "Adaptec AACRAID: afacli (* some controllers supported by USE=aacraid, sys-block/arcconf)"
	einfo "Adaptec ServeRAID 7k: ipssend"
}
