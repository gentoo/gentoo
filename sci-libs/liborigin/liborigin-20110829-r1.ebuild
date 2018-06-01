# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="Library for reading OriginLab OPJ project files"
HOMEPAGE="http://soft.proindependent.com/liborigin2/"
SRC_URI="https://dev.gentoo.org/~dilfridge/distfiles/${PN}2-${PV}.zip"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	dev-libs/boost
	dev-qt/qtcore:5
	dev-qt/qtgui:5
"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-cpp/tree
	doc? ( app-doc/doxygen )
"

DOCS=( readme FORMAT )

S="${WORKDIR}"/${PN}${SLOT}

src_prepare() {
	default

	cat >> liborigin2.pro <<-EOF
		INCLUDEPATH += "${EPREFIX}/usr/include/tree"
		headers.files = \$\$HEADERS
		headers.path = "${EPREFIX}/usr/include/liborigin2"
		target.path = "${EPREFIX}/usr/$(get_libdir)"
		INSTALLS = target headers
	EOF
	# use system one
	rm -f tree.hh || die
}

src_configure() {
	eqmake5 liborigin2.pro
}

src_compile() {
	default
	if use doc; then
		cd doc || die
		doxygen Doxyfile || die "doc generation failed"
	fi
}

src_install() {
	use doc && local HTML_DOCS=( doc/html/. )
	einstalldocs
	emake install INSTALL_ROOT="${D}"
}
