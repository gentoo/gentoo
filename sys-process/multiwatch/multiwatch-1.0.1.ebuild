# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="multiwatch forks and watches multiple instances of a program"
HOMEPAGE="https://redmine.lighttpd.net/projects/multiwatch"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.lighttpd.net/lighttpd/multiwatch.git"
else
	SRC_URI="https://git.lighttpd.net/lighttpd/multiwatch/archive/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}"
fi

LICENSE="MIT"
SLOT="0"

DEPEND="
	dev-libs/libev
	dev-libs/glib:2
"
RDEPEND="${DEPEND}"
