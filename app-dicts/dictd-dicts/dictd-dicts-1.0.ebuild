# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A package to simplify installation of all dictd dictionaries"
HOMEPAGE="http://www.dict.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc amd64 ppc64"
IUSE=""

RDEPEND="app-dicts/dictd-devils
	app-dicts/dictd-elements
	app-dicts/dictd-foldoc
	app-dicts/dictd-gazetteer
	app-dicts/dictd-jargon
	app-dicts/dictd-misc
	app-dicts/dictd-vera
	app-dicts/dictd-web1913
	app-dicts/dictd-wn
"
