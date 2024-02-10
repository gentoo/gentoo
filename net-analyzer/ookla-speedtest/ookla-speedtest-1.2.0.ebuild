# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Internet connection measurement by Ookla"
HOMEPAGE="https://www.speedtest.net/apps/cli"
SRC_URI="
	amd64? ( https://install.speedtest.net/app/cli/${P}-linux-x86_64.tgz )
	arm? ( https://install.speedtest.net/app/cli/${P}-linux-armhf.tgz )
	arm64? ( https://install.speedtest.net/app/cli/${P}-linux-aarch64.tgz )
	x86? ( https://install.speedtest.net/app/cli/${P}-linux-i386.tgz )
"
S="${WORKDIR}"

LICENSE="Ookla"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~arm64 ~x86"
RESTRICT="bindist mirror"

QA_PREBUILT="usr/bin/ookla-speedtest"

src_install() {
	newbin speedtest ookla-speedtest
	newman speedtest.5 ookla-speedtest.5
	newdoc speedtest.md ookla-speedtest.md
}
