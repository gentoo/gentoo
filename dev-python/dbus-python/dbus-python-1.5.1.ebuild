# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
PYTHON_REQ_USE="threads(+)"

inherit meson pypi python-r1

DESCRIPTION="Python bindings for the D-Bus messagebus"
HOMEPAGE="
	https://www.freedesktop.org/wiki/Software/DBusBindings/
	https://dbus.freedesktop.org/doc/dbus-python/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="doc examples test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

DEPEND="
	${PYTHON_DEPS}
	>=sys-apps/dbus-1.8
	>=dev-libs/glib-2.40
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
	doc? (
		$(python_gen_any_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		')
	)
	test? (
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/tap-py[${PYTHON_USEDEP}]
	)
"

python_check_deps() {
	python_has_version "dev-python/sphinx[${PYTHON_USEDEP}]" \
		"dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]"
}

src_configure() {
	use doc && python_setup
	local SPHINX_IMPL=${EPYTHON}

	python_configure() {
		local emesonargs=(
			-Ddoc=disabled
			$(meson_feature test tests)
		)
		if use doc && [[ ${EPYTHON} == ${SPHINX_IMPL} ]]; then
			emesonargs+=(
				-Ddoc=enabled
			)
		fi

		meson_src_configure
	}

	python_foreach_impl python_configure
}

src_compile() {
	python_foreach_impl meson_src_compile
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	python_foreach_impl meson_src_test
}

src_install() {
	python_install() {
		meson_src_install
		python_optimize
	}

	python_foreach_impl python_install

	if use doc; then
		mv "${ED}"/usr/share/doc/dbus-python{,-${PV}} || die
	fi
	use examples && dodoc -r examples
}
