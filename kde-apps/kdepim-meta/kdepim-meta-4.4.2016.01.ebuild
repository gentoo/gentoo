# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_BLOCK_SLOT4="false"
inherit kde5-meta-pkg

DESCRIPTION="kdepim - merge this to pull in all kdepim-derived packages"
HOMEPAGE="https://launchpad.net/~pali/+archive/ubuntu/kdepim-noakonadi"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="nls"
SLOT="4"

RDEPEND="
	kde-frameworks/oxygen-icons:5
	$(add_kdeapps_dep akregator)
	$(add_kdeapps_dep blogilo)
	$(add_kdeapps_dep kabcclient)
	$(add_kdeapps_dep kaddressbook)
	$(add_kdeapps_dep kalarm)
	$(add_kdeapps_dep kdepim-kresources)
	$(add_kdeapps_dep kdepim-wizards)
	$(add_kdeapps_dep kjots)
	$(add_kdeapps_dep kleopatra)
	$(add_kdeapps_dep kmail)
	$(add_kdeapps_dep knode)
	$(add_kdeapps_dep knotes)
	$(add_kdeapps_dep konsolekalendar)
	$(add_kdeapps_dep kontact)
	$(add_kdeapps_dep korganizer)
	$(add_kdeapps_dep ktimetracker)
	$(add_kdeapps_dep libkdepim)
	$(add_kdeapps_dep libkleo)
	$(add_kdeapps_dep libkpgp)
	nls? (
		$(add_kdeapps_dep kde4-l10n '' 4.14.3)
		$(add_kdeapps_dep kdepim-l10n '' 4.4.11.1-r1)
	)
	!kde-apps/kdepim-runtime
"
