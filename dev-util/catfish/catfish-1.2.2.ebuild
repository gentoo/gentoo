# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
inherit eutils gnome2-utils python-single-r1

DESCRIPTION="A frontend for find, (s)locate, doodle, tracker, beagle, strigi and pinot"
HOMEPAGE="https://launchpad.net/catfish-search http://twotoasts.de/index.php/catfish/"
SRC_URI="https://launchpad.net/${PN}-search/${PV%.*}/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

COMMON_DEPEND="
	${PYTHON_DEPS}
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]
"
RDEPEND="
	${COMMON_DEPEND}
	virtual/freedesktop-icon-theme
"
DEPEND="
	${COMMON_DEPEND}
	sys-devel/gettext
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	strip-linguas -i po/
	if ! [[ -z "${LINGUAS}" ]]; then
		local lang langs=$(find po/ -name '*.po' | sed -e 's|po/||g;s|.po||g')
		for lang in $langs; do
			if ! has ${lang} ${LINGUAS}; then
				rm po/${lang}.po || die
			fi
		done
	fi

	python_fix_shebang .
	sed -i -e "s:share/doc/\$(APPNAME):share/doc/${PF}:" Makefile.in.in || die
}

src_configure() {
	# not autotools based
	./configure --prefix=/usr --python="${EPYTHON}" || die
}

src_install() {
	default
	python_optimize "${ED}"/usr/share/${PN}
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
