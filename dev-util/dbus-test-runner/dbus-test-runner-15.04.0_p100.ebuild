# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5,3_6} )
inherit flag-o-matic python-single-r1

DESCRIPTION="Run executables under a new DBus session for testing"
HOMEPAGE="https://launchpad.net/dbus-test-runner"
SRC_URI="https://dev.gentoo.org/~mgorny/dist/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 sparc x86"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/dbus-glib-0.98
	>=dev-libs/glib-2.34:2
	dev-python/dbusmock[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	app-arch/xz-utils
	dev-util/intltool
"
# now optional:
#	test? ( dev-util/bustle )

src_prepare() {
	default

	# bind to specific Python version (with dbusmock installed)
	sed -i -e "s:python3:${EPYTHON}:" \
		libdbustest/dbus-mock.c tests/test-libdbustest-mock.c || die
}

src_configure() {
	append-flags -Wno-error
	econf --disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
