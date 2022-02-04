# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Program for splitting and merging maps in Garmin format"
HOMEPAGE="https://www.gmaptool.eu/"
SRC_URI="https://www.gmaptool.eu/sites/default/files/lgmt${PV}.zip"
S="${WORKDIR}"

LICENSE="CC-BY-SA-3.0 LGPL-2.1+"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

BDEPEND="app-arch/unzip"

QA_PREBUILT="usr/bin/gmt"

src_install() {
	dobin gmt
	dodoc readme.txt
}
