# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils perl-module

DESCRIPTION="Nagios/Icinga plugin to check current server's RAID status"
HOMEPAGE="https://github.com/glensc/nagios-plugin-check_raid"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="3ware aacraid dmraid hpa hpsa i2o megaraid-sas megaraid-scsi mpt mpt-sas2"

DEPEND="dev-perl/Monitoring-Plugin
		dev-perl/Module-Pluggable"
RDEPEND="${DEPEND}
		sys-apps/smartmontools
		sys-fs/lsscsi
		3ware? ( sys-block/tw_cli )
		aacraid? ( sys-block/arcconf )
		dmraid? ( sys-fs/dmraid )
		hpa? ( sys-block/hpacucli )
		hpsa? ( sys-apps/cciss_vol_status )
		i2o? ( sys-apps/raidutils )
		megaraid-sas? ( sys-block/megacli )
		megaraid-scsi? ( sys-block/megarc )
		mpt-sas2? ( sys-block/sas2ircu )
		mpt? ( sys-block/mpt-status )
		"

# TODO:
# Package all the other Perl build pieces, and stop using the monolithic perl script.
src_prepare() {
	# Upstream has a custom Makefile that is meant to build bundles.
	mv -f Makefile Makefile.upstream
	sed -i '/CPANfile/d' Makefile.PL
	default
}

src_install() {
	default
	plugindir="/usr/$(get_libdir)/nagios/plugins"
	dodir "$plugindir"
	mv -f "${D}"/usr/bin/check_raid.pl "${D}"/"${plugindir}"
	dodoc README.md ChangeLog.md CONTRIBUTING.md check_raid.cfg
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
