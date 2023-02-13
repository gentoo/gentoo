# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit python-any-r1

DESCRIPTION="GNU Image Manipulation Program help files"
HOMEPAGE="https://docs.gimp.org/"
SRC_URI="mirror://gimp/help/${P}.tar.bz2"

LICENSE="FDL-1.2"
SLOT="2"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"
IUSE=""

BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-libs/libxml2[python,${PYTHON_USEDEP}]')
	app-text/docbook-xml-dtd
	dev-lang/perl
	dev-libs/libxslt
	sys-devel/gettext
"

# Adds python3 build support, bug 725940
# patch is from https://gitlab.gnome.org/GNOME/gimp-help/-/issues/201
PATCHES=( "${FILESDIR}/${P}-python3.patch" )

python_check_deps() {
	python_has_version "dev-libs/libxml2[python,${PYTHON_USEDEP}]"
}

src_configure() {
	econf --without-gimp
}

src_compile() {
	# See bug: 833566
	python_export_utf8_locale
	# Affected with bugs: 677198, 876205. Set "emake -j1"
	emake -j1
}
