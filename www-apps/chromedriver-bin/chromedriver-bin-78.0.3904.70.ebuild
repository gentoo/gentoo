# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="WebDriver for Chrome"
HOMEPAGE="https://sites.google.com/a/chromium.org/chromedriver"
SRC_URI="amd64? ( https://chromedriver.storage.googleapis.com/${PV}/chromedriver_linux64.zip -> ${P}.linux64.zip )"

LICENSE="google-chrome"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="!www-client/chromium
	www-client/google-chrome"

S="${WORKDIR}"
QA_PREBUILT="usr/bin/chromedriver"

src_install()
{
	dobin chromedriver
}
