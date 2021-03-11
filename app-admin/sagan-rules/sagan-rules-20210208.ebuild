# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Rules for Sagan log analyzer"
HOMEPAGE="https://quadrantsec.com/sagan_log_analysis_engine/"
SRC_URI="https://quadrantsec.com/rules/${P}.tar.gz"
S="${WORKDIR}/rules"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+lognorm"

PDEPEND="app-admin/sagan"

src_install() {
	insinto /etc/sagan-rules
	doins *.config
	doins *rules
	doins *map
	if use lognorm ; then
		doins normalization.rulebase
	fi
}
