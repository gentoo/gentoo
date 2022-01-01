# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The Nagios metapackage"
HOMEPAGE="https://www.nagios.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 sparc ~x86"
IUSE=""

RDEPEND="~net-analyzer/nagios-core-${PV}
	|| ( net-analyzer/nagios-plugins net-analyzer/monitoring-plugins )"
