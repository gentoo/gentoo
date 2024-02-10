# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="PowerShell tab completion and tooltip support for the dotnet CLI"
HOMEPAGE="https://github.com/bergmeister/posh-dotnet/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/bergmeister/${PN}.git"
else
	if [[ "${PV}" == 1.2.3 ]] ; then
		COMMIT="c017886cbad9c4f6ce1fbaa38ebbbcada664655b"

		SRC_URI="https://github.com/bergmeister/${PN}/archive/${COMMIT}.tar.gz
			-> ${P}.tar.gz"
		S="${WORKDIR}"/${PN}-${COMMIT}
	else
		SRC_URI="https://github.com/bergmeister/${PN}/archive/${PV}.tar.gz
			-> ${P}.tar.gz"
	fi

	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="${PV}"
RESTRICT="test"  # Tests fail.

RDEPEND="virtual/pwsh:*"

src_install() {
	insinto "/usr/share/GentooPowerShell/Modules/${PN}/${PV}"
	doins "${PN}.psd1" "${PN}.psm1"

	einstalldocs
}
