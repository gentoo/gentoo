# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Get useful linux system information using PowerShell"
HOMEPAGE="https://github.com/ehmiiz/linuxinfo/"
SRC_URI="https://www.powershellgallery.com/api/v2/package/${PN}/${PV}
	-> ${P}.zip"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="${PV}"
KEYWORDS="~amd64"

RDEPEND="
	virtual/pwsh:*
"
BDEPEND="
	app-arch/unzip
"

src_prepare() {
	default

	rm -f -r '[Content_Types].xml' _rels package || die
}

src_install() {
	insinto "/usr/share/GentooPowerShell/Modules/${PN}/${PV}"
	doins -r .
}
