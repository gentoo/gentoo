# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta ebuild for the Jolly Good API"
HOMEPAGE="https://jgemu.gitlab.io/"

LICENSE="metapackage"
SLOT="1"
KEYWORDS="~amd64"
IUSE="+bsnes +cega +gambatte +jollycv +mednafen melonds +mgba +nestopia +prosystem sameboy +vecx"

RDEPEND="
	bsnes? ( games-emulation/bsnes-jg:1 )
	cega? ( games-emulation/cega-jg:1 )
	gambatte? ( games-emulation/gambatte-jg:1 )
	jollycv? ( games-emulation/jollycv-jg:1 )
	mednafen? ( games-emulation/mednafen-jg:1 )
	melonds? ( games-emulation/melonds-jg:1 )
	mgba? ( games-emulation/mgba-jg:1 )
	nestopia? ( games-emulation/nestopia-jg:1 )
	prosystem? ( games-emulation/prosystem-jg:1 )
	sameboy? ( games-emulation/sameboy-jg:1 )
	vecx? ( games-emulation/vecx-jg:1 )
"
