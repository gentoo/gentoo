# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PALIK
DIST_VERSION=v${PV}
inherit perl-module

DESCRIPTION="Gearman distributed job system - worker/client connector"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	>=dev-perl/Danga-Socket-1.520.0
	>=dev-perl/Gearman-1.07
	!!sys-cluster/gearmand
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Script
	)
"

PATCHES=( "${FILESDIR}/${P}-Use-saner-name-in-process-listing.patch" )

src_install() {
	perl-module_src_install
	newinitd "${FILESDIR}"/gearmand-init.d-1.09 gearmand
	newconfd "${FILESDIR}"/gearmand-conf.d-1.09 gearmand
}
