# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
inherit flag-o-matic python-single-r1

DESCRIPTION="Run executables under a new DBus session for testing"
HOMEPAGE="https://launchpad.net/dbus-test-runner"
SRC_URI="https://launchpad.net/${PN}/$(ver_cut 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# now optional:
#	test? ( dev-util/bustle )
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/intltool
"
COMMON_DEPEND="${PYTHON_DEPS}
	dev-libs/dbus-glib
	dev-libs/glib:2
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-python/dbusmock[${PYTHON_USEDEP}] )
"
RDEPEND="${COMMON_DEPEND}
	dev-python/dbusmock[${PYTHON_USEDEP}]
"

src_prepare() {
	default

	# bind to specific Python version (with dbusmock installed)
	sed -i -e "s:python3:${EPYTHON}:" \
		libdbustest/dbus-mock.c tests/test-libdbustest-mock.c || die
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
