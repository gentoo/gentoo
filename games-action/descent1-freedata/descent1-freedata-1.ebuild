# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DXX_ENGINE="${PN:7:1}"
DESCRIPTION="Free content for games-action/d${DXX_ENGINE}x-rebirth"
HOMEPAGE="https://www.dxx-rebirth.com/"
IUSE="l10n_de opl3-musicpack sc55-musicpack"
SRC_URI="
	l10n_de? ( https://www.dxx-rebirth.com/download/dxx/res/d${DXX_ENGINE}xr-briefings-ger.dxa )
	opl3-musicpack? ( https://www.dxx-rebirth.com/download/dxx/res/d${DXX_ENGINE}xr-opl3-music.dxa )
	sc55-musicpack? ( https://www.dxx-rebirth.com/download/dxx/res/d${DXX_ENGINE}xr-sc55-music.dxa )
"

if [[ "${PN}" = descent1-freedata ]]; then
	IUSE+=" +textures"
	SRC_URI+="
	textures? ( https://www.dxx-rebirth.com/download/dxx/res/d1xr-hires.dxa )
"
fi

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}"

# If all USE flags are unset, this ebuild installs zero files.  Require
# at least one to be set.
REQUIRED_USE="|| ( ${IUSE//+/} )"

RDEPEND="
	!<games-action/dxx-rebirth-0.60
	!games-action/d${DXX_ENGINE}x-rebirth
	"

unset DXX_ENGINE

src_install() {
	local DXX_ENGINE="${PN:7:1}"
	insinto /usr/share/games/d${DXX_ENGINE}x
	use opl3-musicpack && doins "${DISTDIR}"/d${DXX_ENGINE}xr-opl3-music.dxa
	use sc55-musicpack && doins "${DISTDIR}"/d${DXX_ENGINE}xr-sc55-music.dxa
	use l10n_de && doins "${DISTDIR}"/d${DXX_ENGINE}xr-briefings-ger.dxa

	# This ebuild is used for both Descent 1 free data and Descent 2
	# free data.  Only Descent 1 provides alternate textures.
	if [[ "${PN}" = descent1-freedata ]] && use textures; then
		insinto /usr/share/games/d1x
		doins "${DISTDIR}"/d1xr-hires.dxa
	fi
}
