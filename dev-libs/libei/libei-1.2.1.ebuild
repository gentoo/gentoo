# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit meson python-any-r1

DESCRIPTION="Library for Emulated Input, primarily aimed at the Wayland stack"
HOMEPAGE="https://gitlab.freedesktop.org/libinput/libei"
SRC_URI="https://gitlab.freedesktop.org/libinput/${PN}/-/archive/${PV}/${P}.tar.bz2"
MUNIT_COMMIT="fbbdf1467eb0d04a6ee465def2e529e4c87f2118"
SRC_URI+=" https://github.com/nemequ/munit/archive/${MUNIT_COMMIT}.tar.gz -> munit-${MUNIT_COMMIT}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="elogind systemd test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/libevdev-1.9.902
	|| (
		systemd? ( >=sys-apps/systemd-237 )
		elogind? ( >=sys-auth/elogind-237 )
		sys-libs/basu
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	$(python_gen_any_dep '
		dev-python/attrs[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
	')
	test? (
		$(python_gen_any_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/python-dbusmock[${PYTHON_USEDEP}]
			dev-python/pyyaml[${PYTHON_USEDEP}]
			dev-python/structlog[${PYTHON_USEDEP}]
		')
	)
"

python_check_deps() {
	if use test; then
		python_has_version \
			"dev-python/pytest[${PYTHON_USEDEP}]" \
			"dev-python/python-dbusmock[${PYTHON_USEDEP}]" \
			"dev-python/pyyaml[${PYTHON_USEDEP}]" \
			"dev-python/structlog[${PYTHON_USEDEP}]" \
			|| return 1
	fi
	python_has_version \
		"dev-python/attrs[${PYTHON_USEDEP}]" \
		"dev-python/jinja[${PYTHON_USEDEP}]" \
		|| return 1
}

src_unpack() {
	if [[ -n ${A} ]]; then
		unpack ${A}
		mv "${WORKDIR}"/munit-${MUNIT_COMMIT} "${WORKDIR}"/${P}/subprojects/munit || die
		rm "${WORKDIR}"/${P}/subprojects/munit.wrap || die
	fi
}

src_prepare() {
	default

	sed -i -e 's:^valgrind = .*:valgrind = disabler():g' test/meson.build || die
}

src_configure() {
	local emesonargs=(
		-Ddocumentation=""
		-Dliboeffis=enabled
		$(meson_feature test tests)
	)
	if use systemd; then
		emesonargs+=(-Dsd-bus-provider=libsystemd)
	elif use elogind; then
		emesonargs+=(-Dsd-bus-provider=libelogind)
	else
		emesonargs+=(-Dsd-bus-provider=basu)
	fi
	meson_src_configure
}

src_install() {
	meson_src_install

	# munit subproject is installed but not wanted
	if use test; then
		rm "${ED}"/usr/lib*/libmunit.so || die
	fi
}
