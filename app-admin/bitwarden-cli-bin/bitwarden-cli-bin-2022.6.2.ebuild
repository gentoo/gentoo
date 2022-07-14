# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Command line interface for the Bitwarden password manager"
HOMEPAGE="https://bitwarden.com/"
SRC_URI="https://github.com/bitwarden/clients/releases/download/cli-v${PV}/bw-linux-${PV}.zip"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="app-arch/unzip"

QA_PREBUILT="usr/bin/bw"

src_install() {
	dobin bw
}
