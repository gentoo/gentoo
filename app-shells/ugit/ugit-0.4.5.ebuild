# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="PowerShell wrapper for git, automate repos and output git as objects"
HOMEPAGE="https://ugit.start-automating.com/
	https://github.com/StartAutomating/ugit/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/StartAutomating/${PN}.git"
else
	SRC_URI="https://github.com/StartAutomating/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="${PV}"

RDEPEND="
	dev-vcs/git
	virtual/pwsh:*
"

src_install() {
	insinto "/usr/share/GentooPowerShell/Modules/${PN}/${PV}"
	doins "${PN}.psd1"
	doins *.ps1 *.ps1xml *.psm1
	doins -r Commands Extensions Types en-us

	dodoc *.md
}
