# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=no
GNOME_TARBALL_SUFFIX="gz"
PYTHON_COMPAT=( python3_{11..13} pypy3_11 )

inherit gnome.org meson virtualx xdg distutils-r1

DESCRIPTION="Python bindings for GObject Introspection"
HOMEPAGE="
	https://pygobject.gnome.org/
	https://gitlab.gnome.org/GNOME/pygobject/
"
COMMIT=0a8b2c56331a31d7f7096faaa1c1c26467b51c15
SRC_URI+="
	https://github.com/python/pythoncapi-compat/archive/${COMMIT}.tar.gz -> \
		${P}_${COMMIT}_pythoncapi-compat.gh.tar.gz
"
LICENSE="LGPL-2.1+"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="+cairo test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.80:2
	>=dev-libs/gobject-introspection-1.84:=
	dev-libs/libffi:=
	cairo? (
		>=dev-python/pycairo-1.16.0[${PYTHON_USEDEP}]
		x11-libs/cairo[glib]
	)
"
DEPEND="
	${RDEPEND}
	test? (
		>=app-accessibility/at-spi2-core-2.46.0[introspection]
		dev-python/pytest[${PYTHON_USEDEP}]
		x11-libs/gdk-pixbuf:2[introspection,jpeg]
		x11-libs/gtk+:3[introspection]
		x11-libs/pango[introspection]
	)
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/Skip-test-using-dbus-in-sandbox.patch"
	"${FILESDIR}/Skip-test-detecting-cycle-among-base-classes-typeerr.patch"
)

src_unpack() {
	default
	unpack "${P}_${COMMIT}_pythoncapi-compat.gh.tar.gz" || die
}

src_prepare() {
	default
	find  "${S}/subprojects/pythoncapi-compat" -mindepth 1  ! -name meson.build -exec rm -vrf {} + || die
	mv -v "${WORKDIR}/pythoncapi-compat-${COMMIT}"/* "${S}/subprojects/pythoncapi-compat" || die
}

python_configure() {
	local emesonargs=(
		$(meson_feature cairo pycairo)
		$(meson_use test tests)
		-Dpython="${EPYTHON}"
	)
	meson_src_configure
}

python_compile() {
	meson_src_compile
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	local -x GIO_USE_VFS="local" # prevents odd issues with deleting ${T}/.gvfs
	local -x GIO_USE_VOLUME_MONITOR="unix" # prevent udisks-related failures in chroots, bug #449484
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x XDG_CACHE_HOME="${T}/${EPYTHON}"
	meson_src_test --timeout-multiplier 3 || die "test failed for ${EPYTHON}"
}

python_install() {
	meson_src_install
	python_optimize
}
