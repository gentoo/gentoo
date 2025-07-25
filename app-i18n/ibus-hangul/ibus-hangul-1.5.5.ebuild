# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit autotools gnome2-utils python-single-r1 xdg virtualx

DESCRIPTION="Korean Hangul engine for IBus"
HOMEPAGE="https://github.com/libhangul/ibus-hangul/wiki"
SRC_URI="https://github.com/libhangul/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		app-i18n/ibus[python(+),${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	>=app-i18n/libhangul-0.1
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-test.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		--with-python=${EPYTHON}
}

src_test() {
	"${BROOT}"${GLIB_COMPILE_SCHEMAS} --allow-any-name "${S}"/data || die

	export GSETTINGS_BACKEND="memory"
	export GSETTINGS_SCHEMA_DIR="${S}/data"
	virtx default
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_schemas_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
