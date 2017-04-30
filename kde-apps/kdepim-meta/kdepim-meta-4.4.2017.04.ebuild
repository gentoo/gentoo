# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_BLOCK_SLOT4="false"
inherit kde5-meta-pkg

DESCRIPTION="kdepim - merge this to pull in all kdepim-derived packages"
HOMEPAGE="https://launchpad.net/~pali/+archive/ubuntu/kdepim-noakonadi"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="nls"
SLOT="4"

RDEPEND="
	=kde-apps/akregator-4.4.2017*:4
	=kde-apps/blogilo-4.4.2017*:4
	=kde-apps/kabcclient-4.4.2017*:4
	=kde-apps/kaddressbook-4.4.2017*:4
	=kde-apps/kalarm-4.4.2017*:4
	=kde-apps/kdepim-kresources-4.4.2017*:4
	=kde-apps/kdepim-wizards-4.4.2017*:4
	=kde-apps/kjots-4.4.2017*:4
	=kde-apps/kleopatra-4.4.2017*:4
	=kde-apps/kmail-4.4.2017*:4
	=kde-apps/knode-4.4.2017*:4
	=kde-apps/knotes-4.4.2017*:4
	=kde-apps/konsolekalendar-4.4.2017*:4
	=kde-apps/kontact-4.4.2017*:4
	=kde-apps/korganizer-4.4.2017*:4
	=kde-apps/ktimetracker-4.4.2017*:4
	=kde-apps/libkdepim-4.4.2017*:4
	=kde-apps/libkleo-4.4.2017*:4
	=kde-apps/libkpgp-4.4.2017*:4
	kde-frameworks/oxygen-icons:5
	nls? (
		>=kde-apps/kde4-l10n-4.14.3:4
		>=kde-apps/kdepim-l10n-4.4.11.1-r1:4
	)
	!kde-apps/kdepim-runtime
"
