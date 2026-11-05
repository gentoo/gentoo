# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See https://googlechromelabs.github.io/chrome-for-testing/#stable for URLs
DESCRIPTION="WebDriver for Chrome"
HOMEPAGE="https://sites.google.com/corp/chromium.org/driver/"
SRC_URI="
	amd64? ( https://storage.googleapis.com/chrome-for-testing-public/${PV}/linux64/chromedriver-linux64.zip -> ${P}.linux64.zip )
	arm64? ( https://storage.googleapis.com/chrome-for-testing-public/${PV}/linux-arm64/chromedriver-linux-arm64.zip -> ${P}.linux-arm64.zip )
"
S="${WORKDIR}"

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

pkg_pretend() {
	# Protect against people using autounmask overzealously
	use amd64 || use arm64 || die "${PN} only works on supported architectures"
}

src_install() {
	if use amd64; then
		cd chromedriver-linux64 || die
	elif use arm64; then
		cd chromedriver-linux-arm64 || die
	fi
	dobin chromedriver
}
