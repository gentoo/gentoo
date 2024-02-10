# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="WebDriver for Chrome"
HOMEPAGE="https://sites.google.com/corp/chromium.org/driver/"
SRC_URI="amd64? ( https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/${PV}/linux64/chromedriver-linux64.zip -> ${P}.linux64.zip )"
S="${WORKDIR}/chromedriver-linux64/"

LICENSE="google-chrome"
SLOT="0"
KEYWORDS="-* amd64"
RESTRICT="bindist mirror strip"

RDEPEND="
	sys-libs/glibc
	www-client/google-chrome
	!www-client/chromium
"
BDEPEND="app-arch/unzip"

QA_PREBUILT="usr/bin/chromedriver"

src_install() {
	dobin chromedriver
}
