# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for PowerShell"

SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64"

RDEPEND="
	|| (
		app-shells/pwsh-bin:${SLOT}
		app-shells/pwsh:${SLOT}
	)
"
