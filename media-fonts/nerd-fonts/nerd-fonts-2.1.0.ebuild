# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Icon patched versions of popular fonts"
HOMEPAGE="https://nerdfonts.com/"

KEYWORDS="~amd64 ~arm64 ~x86"
S="${WORKDIR}"

MY_FONTS=(
	3270
	Agave
	AnonymousPro
	Arimo
	AurulentSansMono
	BigBlueTerminal
	BitstreamVeraSansMono
	CascadiaCode
	CodeNewRoman
	Cousine
	DaddyTimeMono
	DejaVuSansMono
	DroidSansMono
	FantasqueSansMono
	FiraCode
	FiraMono
	Go-Mono
	Gohu
	Hack
	Hasklig
	HeavyData
	Hermit
	iA-Writer
	IBMPlexMono
	Inconsolata
	InconsolataGo
	InconsolataLGC
	Iosevka
	JetBrainsMono
	Lekton
	LiberationMono
	Meslo
	Monofur
	Monoid
	Mononoki
	MPlus
	Noto
	OpenDyslexic
	Overpass
	ProFont
	ProggyClean
	RobotoMono
	ShareTechMono
	SourceCodePro
	SpaceMono
	Terminus
	Tinos
	Ubuntu
	UbuntuMono
	VictorMono
)

for MY_FONT in ${MY_FONTS[@]}; do
	SRC_URI+=" ${MY_FONT,,}? ( https://github.com/ryanoasis/nerd-fonts/releases/download/v${PV}/${MY_FONT}.zip -> ${P}-${MY_FONT}.zip )"
done

LICENSE="MIT"
SLOT="0"
IUSE="${MY_FONTS[@],,}"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"
FONT_SUFFIX="ttf otf"
