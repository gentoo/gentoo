# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta ebuild for the Jolly Good API"
HOMEPAGE="https://jgemu.gitlab.io/"

LICENSE="metapackage"
SLOT="1"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+bsnes +cega +gambatte +geolith +jollycv +mednafen melonds +mgba +nestopia +prosystem sameboy +vecx"

RDEPEND="
	bsnes? ( games-emulation/bsnes-jg )
	cega? ( games-emulation/cega-jg )
	gambatte? ( games-emulation/gambatte-jg )
	geolith? ( games-emulation/geolith-jg )
	jollycv? ( games-emulation/jollycv-jg )
	mednafen? ( games-emulation/mednafen-jg )
	melonds? ( games-emulation/melonds-jg )
	mgba? ( games-emulation/mgba-jg )
	nestopia? ( games-emulation/nestopia-jg )
	prosystem? ( games-emulation/prosystem-jg )
	sameboy? ( games-emulation/sameboy-jg )
	vecx? ( games-emulation/vecx-jg )
"
