# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit bash-completion-r1 meson python-any-r1 virtualx xdg-utils

DESCRIPTION="A CLI utility to control media players over MPRIS"
HOMEPAGE="https://github.com/acrisci/playerctl"
SRC_URI="https://github.com/acrisci/playerctl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="doc introspection test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.38:2
	introspection? ( dev-libs/gobject-introspection:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
	introspection? ( dev-libs/gobject-introspection )
	test? (
		${PYTHON_DEPS}
		sys-apps/dbus
		$(python_gen_any_dep '
			dev-python/dbus-next[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-asyncio[${PYTHON_USEDEP}]
			dev-python/pytest-timeout[${PYTHON_USEDEP}]
		')
	)
"

EPYTEST_DESELECT=(
	# Requires a lenient dbus config systemwide
	# See test/data/dbus-system.conf and how its used in Dockerfile
	"test/test_basics.py::test_system_list_players"
	# Daemon tests are inconsistent, occasional failure occurs in upstream CI as well.
	"test/test_daemon.py"
)

python_check_deps() {
	python_has_version \
		"dev-python/dbus-next[${PYTHON_USEDEP}]" \
		"dev-python/pytest[${PYTHON_USEDEP}]" \
		"dev-python/pytest-asyncio[${PYTHON_USEDEP}]" \
		"dev-python/pytest-timeout[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		-Ddatadir=share
		-Dbindir=bin
		-Dbash-completions=false
		-Dzsh-completions=false
		$(meson_use doc gtk-doc)
		$(meson_use introspection)
	)

	xdg_environment_reset # bug #596166
	meson_src_configure
}

src_test() {
	local dbus_params=(
		$(dbus-daemon --session --print-address --fork --print-pid)
	)
	local -x DBUS_SESSION_BUS_ADDRESS=${dbus_params[0]}

	export PATH="${BUILD_DIR}/playerctl/:${PATH}"

	virtx epytest --asyncio-mode=auto

	kill "${dbus_params[1]}" || die
}

src_install() {
	meson_src_install

	docinto examples
	dodoc -r "${S}"/examples/.
	docompress -x "/usr/share/doc/${PF}/examples"

	newbashcomp data/playerctl.bash "${PN}"
	insinto /usr/share/zsh/site-functions
	newins data/playerctl.zsh _playerctl
}
