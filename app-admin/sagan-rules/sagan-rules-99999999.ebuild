# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Rules for Sagan log analyzer"
HOMEPAGE="http://sagan.softwink.com/"
EGIT_REPO_URI="https://github.com/beave/sagan-rules.git"

LICENSE="BSD"
SLOT="0"
IUSE="+lognorm"

PDEPEND="app-admin/sagan"

src_install() {
	insinto /etc/sagan-rules
	doins *.config
	doins *rules
	if use lognorm; then
		doins normalization.rulebase
	fi
}
