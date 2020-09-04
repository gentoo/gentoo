# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="A hardware health information viewer, interface to lm-sensors"
HOMEPAGE="https://github.com/Mystro256/xsensors/"
SRC_URI="https://github.com/Mystro256/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	>=sys-apps/lm-sensors-3
	dev-libs/glib:2
	x11-libs/gtk+:3
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default

	sed -i \
		-e '/-DG.*_DISABLE_DEPRECATED/d' \
		-e 's#-Werror#-Wall#g' \
		-e 's#==#=#g' \
		-e 's#pkg-config#${PKG_CONFIG}#g' \
		src/Makefile.am configure.ac || die

	eautoreconf
}

src_configure() {
	econf --without-gtk2
}

src_install() {
	default

	rm -r "${ED}"/usr/share/appdata || die
}
