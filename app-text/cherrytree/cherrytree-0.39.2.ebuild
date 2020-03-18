# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit autotools desktop python-any-r1 xdg-utils

DESCRIPTION="A hierarchical note taking application"
HOMEPAGE="https://www.giuspen.com/cherrytree"
SRC_URI="https://github.com/giuspen/cherrytree/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/gtkmm:3.0
	dev-cpp/gtksourceviewmm:3.0
	dev-cpp/libxmlpp:2.6
	dev-cpp/pangomm
	dev-db/sqlite:3
	dev-libs/libxml2:2"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	test? ( dev-util/cpputest )"

S="${S}/future"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	default

	python_fix_shebang "${S}"

	sed -i \
		-e "s|\(CT_VERSION.*{\)\(.*\)\(};\)$|\1\"${PV}\"\3|" \
		src/ct/ct_const.cc || die

	if ! use test; then
		sed -i \
			-e '/^PKG_CHECK_MODULES/s|\(\[.*\)cpputest\(.*\]\)|\1\2|' \
			configure.ac || die
	fi

	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default
	pushd ../ >/dev/null || die

	insinto /usr/share/mime/packages
	doins linux/cherrytree.xml

	insinto /usr/share/mime-info
	doins linux/cherrytree.{mime,keys}

	insinto /usr/share/metainfo
	doins linux/cherrytree.appdata.xml

	insinto /usr/share/application-registry
	doins linux/cherrytree.applications

	doicon -s scalable future/icons/cherrytree.svg
	domenu linux/cherrytree.desktop
	doman linux/cherrytree.1

	popd >/dev/null || die
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
