# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="command line interface for the 1password password manager"
HOMEPAGE="https://1password.com/downloads/command-line"
SITE="https://cache.agilebits.com/dist/1P/op/pkg/v${PV}/"
SRC_URI="${SITE}/op_linux_amd64_v${PV}.zip"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="app-arch/unzip"

QA_PREBUILT="usr/bin/op"
RESTRICT="bindist mirror"
S="${WORKDIR}"

src_install() {
	dobin op
}
