# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit autotools gnome2-utils python-single-r1

DESCRIPTION="A utility for viewing problems that have occurred with the system"
HOMEPAGE="https://github.com/abrt/abrt/wiki/ABRT-Project"
SRC_URI="https://github.com/abrt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	x11-libs/gtk+:3
	>=dev-libs/libreport-2.0.20[python]
	>=app-admin/abrt-2.10.10-r1
	dev-python/pygobject:3
	x11-libs/libX11
	>=dev-python/pyxdg-0.19
"
DEPEND="${RDEPEND}
	app-text/asciidoc
	app-text/xmlto
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
	>=sys-devel/gettext-0.17
"

PATCHES=(
	# From Fedora (fixed in next release)
	"${FILESDIR}"/0001-Remove-Expert-mode-and-the-remaining-Analyze-code.patch
)

src_prepare() {
	default
	./gen-version > gnome-abrt-version || die
	eautoreconf
}

src_configure() {
	myeconfargs=(
		--localstatedir="${EPREFIX}/var"
		--with-nopylint
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
