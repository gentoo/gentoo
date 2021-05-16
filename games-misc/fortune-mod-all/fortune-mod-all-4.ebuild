# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta package for all fortune-mod packages"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="l10n_cs l10n_de l10n_it"

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
	games-misc/fortune-mod-bofh-excuses
	games-misc/fortune-mod-chucknorris
	games-misc/fortune-mod-kernelcookies
	games-misc/fortune-mod-osfortune
	games-misc/fortune-mod-tao
	games-misc/fortune-mod-zx-error"
