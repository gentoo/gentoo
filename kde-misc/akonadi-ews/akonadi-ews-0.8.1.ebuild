# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="Akonadi resource for Microsoft Exchange Web Services"
HOMEPAGE="https://github.com/KrissN/akonadi-ews"

if [[ ${KDE_BUILD_TYPE} = live ]] ; then
	EGIT_REPO_URI="https://github.com/KrissN/${PN}.git"
else
	SRC_URI="https://github.com/KrissN/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_kdeapps_dep akonadi)
	$(add_kdeapps_dep akonadi-mime)
	$(add_kdeapps_dep kcalcore)
	$(add_kdeapps_dep kcontacts)
	$(add_kdeapps_dep kmime)
"
DEPEND="${RDEPEND}
	dev-libs/libxslt"

DOCS=( README.md )
