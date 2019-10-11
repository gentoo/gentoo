# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION="Meta package for all fortune-mod packages"
HOMEPAGE="https://www.gentoo.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~sh ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="l10n_cs l10n_de l10n_it l10n_sk offensive"

RDEPEND="games-misc/fortune-mod
	l10n_cs? ( games-misc/fortune-mod-cs )
	l10n_de? (
		games-misc/fortune-mod-at-linux
		games-misc/fortune-mod-norbert-tretkowski
		games-misc/fortune-mod-thomas-ogrisegg
		games-misc/fortune-mod-fvl
		games-misc/fortune-mod-rss
	)
	l10n_it? ( games-misc/fortune-mod-it )
	l10n_sk? ( games-misc/fortune-mod-debilneho )
	games-misc/fortune-mod-bofh-excuses
	games-misc/fortune-mod-calvin
	games-misc/fortune-mod-chucknorris
	games-misc/fortune-mod-dubya
	games-misc/fortune-mod-familyguy
	games-misc/fortune-mod-firefly
	games-misc/fortune-mod-futurama
	games-misc/fortune-mod-gentoo-dev
	games-misc/fortune-mod-gentoo-forums
	games-misc/fortune-mod-hitchhiker
	games-misc/fortune-mod-homer
	games-misc/fortune-mod-humorixfortunes
	games-misc/fortune-mod-kernelcookies
	games-misc/fortune-mod-osfortune
	games-misc/fortune-mod-powerpuff
	games-misc/fortune-mod-pqf
	games-misc/fortune-mod-simpsons-chalkboard
	offensive? ( games-misc/fortune-mod-slackware[offensive] )
	games-misc/fortune-mod-smac
	games-misc/fortune-mod-sp-fortunes
	games-misc/fortune-mod-starwars
	games-misc/fortune-mod-strangelove
	games-misc/fortune-mod-tao
	games-misc/fortune-mod-zx-error"
