# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Rules for Sagan log analyzer"
HOMEPAGE="https://github.com/quadrantsec/sagan-rules"
SRC_URI="https://quadrantsec.com/rules/${P}.tar.gz"
S="${WORKDIR}/rules"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

src_install() {
	insinto /etc/sagan-rules
	doins *.config
	doins *rules
	doins *map
	doins normalization.rulebase
}
