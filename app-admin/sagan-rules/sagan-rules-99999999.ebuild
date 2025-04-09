# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

EGIT_REPO_URI="https://github.com/beave/sagan-rules.git"

DESCRIPTION="Rules for Sagan log analyzer"
HOMEPAGE="https://github.com/quadrantsec/sagan-rules"

LICENSE="BSD"
SLOT="0"

src_install() {
	insinto /etc/sagan-rules
	doins *.config
	doins *rules
	doins *map
	doins normalization.rulebase
}
