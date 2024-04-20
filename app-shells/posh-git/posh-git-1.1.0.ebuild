# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A PowerShell environment for Git"
HOMEPAGE="http://dahlbyk.github.io/posh-git/
	https://github.com/dahlbyk/posh-git/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/dahlbyk/${PN}.git"
else
	SRC_URI="https://github.com/dahlbyk/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="${PV}"

RDEPEND="
	virtual/pwsh:*
	dev-vcs/git
"

DOCS=( CHANGELOG.md ISSUE_TEMPLATE.md README.md profile.example.ps1 )

src_install() {
	insinto "/usr/share/GentooPowerShell/Modules/${PN}/${PV}"
	doins -r src/.

	einstalldocs
}
