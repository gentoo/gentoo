# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python3_6 )

inherit python-r1

DESCRIPTION="Sabayon distro-agnostic images build tool"
HOMEPAGE="https://www.sabayon.org"
SRC_URI="mirror://sabayon/${CATEGORY}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="dev-util/intltool
	sys-devel/gettext"
RDEPEND="
	sys-process/lsof
	${PYTHON_DEPS}"

src_install() {
	emake DESTDIR="${D}" LIBDIR="/usr/lib" \
		PREFIX="/usr" SYSCONFDIR="/etc" install
}
