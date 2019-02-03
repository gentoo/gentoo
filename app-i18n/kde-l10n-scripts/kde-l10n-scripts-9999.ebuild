# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Set of scripts to manage KDE translation files"
HOMEPAGE="https://github.com/vpelcak/kde-scripts"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/vpelcak/kde-scripts.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	app-crypt/md5deep
	app-i18n/pology
	app-shells/bash:*
	dev-vcs/subversion
	kde-apps/poxml
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i \
		-e "s:/usr/local:${EPREFIX}/usr:" \
		Makefile || die
}
