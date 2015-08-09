# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="git://github.com/vpelcak/kde-scripts.git"
[[ ${PV} == 9999 ]] && inherit git-2

DESCRIPTION="Set of scripts to manage KDE translation files"
HOMEPAGE="https://github.com/vpelcak/kde-scripts"
[[ ${PV} == 9999 ]] || SRC_URI=""

LICENSE="LGPL-3"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	app-crypt/md5deep
	app-i18n/pology
	app-shells/bash:*
	dev-vcs/subversion
	kde-apps/poxml[extras]
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i \
		-e "s:/usr/local:/usr:" \
		Makefile || die
}
