# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="PowerShell module that helps to understand, use, and build regular expressions"
HOMEPAGE="https://irregular.start-automating.com/
	https://github.com/StartAutomating/Irregular/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/StartAutomating/${PN^}.git"
else
	SRC_URI="https://github.com/StartAutomating/${PN^}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${P^}"

	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="${PV}"

RDEPEND="virtual/pwsh:*"

src_install() {
	insinto "/usr/share/GentooPowerShell/Modules/${PN^}/${PV}"
	doins "${PN^}.psd1"
	doins *.ps1 *.ps1xml *.psm1
	doins -r Formatting RegEx Types en-us

	dodoc *.md
}
