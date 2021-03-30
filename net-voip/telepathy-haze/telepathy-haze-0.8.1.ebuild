# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit python-any-r1

DESCRIPTION="Telepathy connection manager providing libpurple supported protocols"
HOMEPAGE="https://telepathy.freedesktop.org https://developer.pidgin.im/wiki/TelepathyHaze"
SRC_URI="https://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	net-im/pidgin[dbus]
	net-libs/telepathy-glib
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-libs/libxslt
	dev-util/glib-utils
	virtual/pkgconfig
	test? (
		dev-python/pygobject:3
		$(python_gen_any_dep 'dev-python/twisted[${PYTHON_USEDEP}]')
	)
"

python_check_deps() {
	if use test ; then
		has_version "dev-python/twisted[${PYTHON_USEDEP}]"
	fi
}
