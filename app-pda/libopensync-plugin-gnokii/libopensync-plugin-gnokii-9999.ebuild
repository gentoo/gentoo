# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit cmake-utils subversion

DESCRIPTION="OpenSync Gnokii Plugin"
HOMEPAGE="http://www.opensync.org/"
SRC_URI=""

ESVN_REPO_URI="http://svn.opensync.org/plugins/gnokii-sync"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="=app-pda/libopensync-${PV}*
	>=app-mobilephone/gnokii-0.6.14"
RDEPEND="${DEPEND}"
