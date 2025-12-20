# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit flag-o-matic meson python-single-r1 xdg

COMMIT_HASH="22534d16c317ee11714ef7221f9b635df233be9b"
MAN_DATE="2004-11-26"
DESCRIPTION="Diagram/flowchart creation program"
HOMEPAGE="https://wiki.gnome.org/Apps/Dia"
SRC_URI="https://gitlab.gnome.org/GNOME/${PN}/-/archive/${COMMIT_HASH}/${PN}-${COMMIT_HASH}.tar.bz2"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/dia-0.98-patches.tar.xz"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~ppc ppc64 ~riscv ~sparc x86"
IUSE="doc pdf python wmf xslt X"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	>=dev-libs/glib-2.76:2
	>=dev-libs/libxml2-2.14:=
	>=media-libs/graphene-1.10
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.24:3[X?]
	x11-libs/pango
	pdf? ( >=app-text/poppler-21.03.0:=[cxx] )
	python? ( ${PYTHON_DEPS} )
	wmf? ( media-libs/libemf )
	xslt? ( dev-libs/libxslt )
"
RDEPEND="
	${DEPEND}
	python? ( $(python_gen_cond_dep 'dev-python/pygobject[${PYTHON_USEDEP}]') )
"
BDEPEND="
	dev-util/desktop-file-utils
	dev-util/glib-utils
	sys-devel/gettext
	virtual/pkgconfig
	doc? (
		app-text/docbook-xml-dtd
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt
	)
"

PATCHES=(
	"${WORKDIR}"/dia-0.98-patches/${PN}-0.98-revert_xpm_replacement.patch
	"${WORKDIR}"/dia-0.98-patches/${PN}-0.98-use_gtkfontbutton.patch
	"${WORKDIR}"/dia-0.98-patches/${PN}-0.98-deps_optional.patch
	"${FILESDIR}"/${PN}-0.98-fix_poppler_2510.patch #965768
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	# avoid doc in /usr/share/dia/help
	# do not build pdf with dblatex
	sed -e "s:^helpdir =.*$:helpdir = datadir / 'doc' / '${PF}' / 'html':" \
		-e "/^dblatex = /s:find_program(.*):disabler():" \
		-i doc/meson.build || die
	sed -e "/.*helpdir =.*$/s:\"help\":\"../doc/${PF}/html\":" \
		-i app/commands.c || die

	# use local docbook
	sed -e "s:^DB2MAN =.*$:DB2MAN = '${EPREFIX}/usr/share/sgml/docbook/xsl-stylesheets/manpages/docbook.xsl':" \
		-i doc/meson.build || die
}

src_configure() {
	use pdf && append-cxxflags -std=c++20

	# 'if(n)def GDK_WINDOWING_X11' for clipboard and font context
	use X || append-cppflags -DGENTOO_GTK_HIDE_X11

	local emesonargs=(
		$(meson_feature doc)
		-Dpdf=$(usex pdf true false)
		-Dpython=$(usex python true false)
		# from tests/meson.build "Most of these tests are currently broken"
		-Dtests=false
		-Dwmf=$(usex wmf true false)
		-Dxslt=$(usex xslt true false)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	use doc || newman "${FILESDIR}"/${PN}-${MAN_DATE}.1 ${PN}.1

	if use python; then
		python_fix_shebang "${ED}"/usr/share/dia
		python_optimize "${ED}"/usr/share/dia
	fi
}
