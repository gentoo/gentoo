# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit python-single-r1

DESCRIPTION="Run executables under a new DBus session for testing"
HOMEPAGE="https://launchpad.net/dbus-test-runner"
SRC_URI="https://launchpad.net/${PN}/$(ver_cut 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv sparc x86"
IUSE="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

COMMON_DEPEND="${PYTHON_DEPS}
	dev-libs/dbus-glib
	dev-libs/glib:2
"
DEPEND="${COMMON_DEPEND}
	test? (
		$(python_gen_cond_dep '
			dev-python/python-dbusmock[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND="${COMMON_DEPEND}
	$(python_gen_cond_dep '
		dev-python/python-dbusmock[${PYTHON_USEDEP}]
	')
"
# hard-disabled:
#	test? ( dev-util/bustle )
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/intltool
"

PATCHES=( "${FILESDIR}"/${P}-fix-deprecation-warnings.patch ) # Debian patch

src_prepare() {
	default

	# bind to specific Python version (with python-dbusmock installed)
	sed -i -e "s:python3:${EPYTHON}:" \
		libdbustest/dbus-mock.c tests/test-libdbustest-mock.c || die
}

src_configure() {
	econf ac_cv_prog_have_bustle=no
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
