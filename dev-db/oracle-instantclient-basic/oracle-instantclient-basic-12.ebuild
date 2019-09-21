# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Transition package moving to single ${CATEGORY}/oracle-instantclient package"
HOMEPAGE="https://bugs.gentoo.org/show_bug.cgi?id=524922#c12"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-db/oracle-instantclient-12[sdk]"
