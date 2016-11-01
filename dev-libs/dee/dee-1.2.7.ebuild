# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 )

AUTOTOOLS_AUTORECONF=y

inherit autotools-utils vala python-r1

DESCRIPTION="Provide objects allowing to create Model-View-Controller type programs across DBus"
HOMEPAGE="https://launchpad.net/dee/"
SRC_URI="https://launchpad.net/dee/1.0/${PV}/+download/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="doc debug examples +icu introspection static-libs test"

REQUIRED_USE="introspection? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/glib:2
	dev-libs/icu:=
	introspection? (
		${PYTHON_DEPS}
		dev-libs/gobject-introspection
		)"
DEPEND="${RDEPEND}
	$(vala_depend)
	doc? ( dev-util/gtk-doc )
	test? (
		dev-libs/gtx
		dev-util/dbus-test-runner
		)"

src_prepare() {
	sed \
		-e '/GCC_FLAGS/s:-g::' \
		-e 's:vapigen:${VAPIGEN}:g' \
		-i configure.ac || die

	sed \
		-e 's:bindings::g' \
		-i Makefile.am || die

	vala_src_prepare
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--disable-silent-rules
		$(use_enable debug trace-log)
		$(use_enable doc gtk-doc)
		$(use_enable icu)
		$(use_enable test tests)
#		$(use_enable test extended-tests)
		)
	autotools-utils_src_configure
	use introspection && python_copy_sources
}

src_compile() {
	autotools-utils_src_compile

	compilation() {
		cd bindings || die
		emake \
			pyexecdir="$(python_get_sitedir)"
	}
	use introspection && python_foreach_impl run_in_build_dir compilation
}

src_install() {
	autotools-utils_src_install

	if use examples; then
		insinto /usr/share/doc/${PN}/
		doins -r examples
	fi

	installation() {
		cd bindings || die
		emake \
			PYGI_OVERRIDES_DIR="$(python_get_sitedir)"/gi/overrides \
			DESTDIR="${D}" \
			install
	}
	use introspection && python_foreach_impl run_in_build_dir installation
}
