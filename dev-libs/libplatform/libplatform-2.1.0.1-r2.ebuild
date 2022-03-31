# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="platform"
MY_PN_PREFIX="p8"

DESCRIPTION="Platform support library used by libCEC and binary add-ons for Kodi"
HOMEPAGE="https://github.com/Pulse-Eight/platform"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/Pulse-Eight/${MY_PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/Pulse-Eight/${MY_PN}/archive/${MY_PN_PREFIX}-${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_PN}-${MY_PN_PREFIX}-${MY_PN}-${PV}"
	KEYWORDS="amd64 ~arm ~arm64 ~x86"
fi
