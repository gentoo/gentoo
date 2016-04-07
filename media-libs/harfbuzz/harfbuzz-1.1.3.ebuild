# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="git://anongit.freedesktop.org/harfbuzz"
[[ ${PV} == 9999 ]] && inherit git-r3 autotools

PYTHON_COMPAT=( python2_7 )

inherit eutils libtool multilib-minimal python-any-r1 xdg-utils

DESCRIPTION="An OpenType text shaping engine"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/HarfBuzz"
[[ ${PV} == 9999 ]] || SRC_URI="http://www.freedesktop.org/software/${PN}/release/${P}.tar.bz2"

LICENSE="Old-MIT ISC icu"
SLOT="0/0.9.18" # 0.9.18 introduced the harfbuzz-icu split; bug #472416
[[ ${PV} == 9999 ]] || \
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~x86-macos ~x64-solaris"

IUSE="+cairo fontconfig +glib +graphite icu +introspection static-libs test +truetype"
REQUIRED_USE="introspection? ( glib )"

RDEPEND="
	cairo? ( x11-libs/cairo:= )
	fontconfig? ( media-libs/fontconfig:1.0[${MULTILIB_USEDEP}] )
	glib? ( >=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}] )
	graphite? ( >=media-gfx/graphite2-1.2.1:=[${MULTILIB_USEDEP}] )
	icu? ( >=dev-libs/icu-51.2-r1:=[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.34:= )
	truetype? ( >=media-libs/freetype-2.5.0.1:2=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig
	test? ( ${PYTHON_DEPS} )
"
# eautoreconf requires gobject-introspection-common
# ragel needed if regenerating *.hh files from *.rl
[[ ${PV} = 9999 ]] && DEPEND="${DEPEND}
	>=dev-libs/gobject-introspection-common-1.34
	dev-util/ragel
"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	xdg_environment_reset

	if [[ ${CHOST} == *-darwin* || ${CHOST} == *-solaris* ]] ; then
		# on Darwin/Solaris we need to link with g++, like automake defaults
		# to, but overridden by upstream because on Linux this is not
		# necessary, bug #449126
		sed -i \
			-e 's/\<LINK\>/CXXLINK/' \
			src/Makefile.am || die
		sed -i \
			-e '/libharfbuzz_la_LINK = /s/\<LINK\>/CXXLINK/' \
			src/Makefile.in || die
		sed -i \
			-e '/AM_V_CCLD/s/\<LINK\>/CXXLINK/' \
			test/api/Makefile.in || die
	fi

	[[ ${PV} == 9999 ]] && eautoreconf
	elibtoolize # for Solaris

	# failing test, https://bugs.freedesktop.org/show_bug.cgi?id=89190
	sed -e 's#tests/arabic-fallback-shaping.tests##' -i test/shaping/Makefile.in || die "sed failed"
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	# harfbuzz-gobject only used for instrospection, bug #535852
	econf \
		--without-coretext \
		--without-uniscribe \
		$(use_enable static-libs static) \
		$(multilib_native_use_with cairo) \
		$(use_with fontconfig) \
		$(use_with glib) \
		$(use_with introspection gobject) \
		$(use_with graphite graphite2) \
		$(use_with icu) \
		$(multilib_native_use_enable introspection) \
		$(use_with truetype freetype)

	if multilib_is_native_abi; then
		ln -s "${S}"/docs/html docs/html || die
	fi
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --modules
}
