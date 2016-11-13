# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit gnome2 python-r1 vala

DESCRIPTION="Provide objects allowing to create Model-View-Controller type programs across DBus"
HOMEPAGE="https://launchpad.net/dee/"
SRC_URI="https://launchpad.net/dee/1.0/${PV}/+download/${P}.tar.gz"

SLOT="0/4"
LICENSE="GPL-3"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug examples +icu introspection static-libs test"

REQUIRED_USE="introspection? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/glib:2
	icu? ( dev-libs/icu:= )
	introspection? (
		${PYTHON_DEPS}
		>=dev-libs/gobject-introspection-0.10.2:=
	)
"
DEPEND="${RDEPEND}
	$(vala_depend)
	>=dev-util/gtk-doc-am-1.8
	virtual/pkgconfig
	test? (
		>=dev-libs/gtx-0.2.2
		dev-util/dbus-test-runner
	)
"

src_prepare() {
	# Fix build with gcc-6, bug #594112
	eapply "${FILESDIR}"/${PN}-1.2.7-gcc-6-build.patch

	sed \
		-e 's:VALA_API_GEN:VAPIGEN:g' \
		-i vapi/Makefile.{am,in} || die

	sed \
		-e '/SUBDIRS/ s:bindings::g' \
		-i Makefile.{am,in} || die

	vala_src_prepare
	gnome2_src_prepare

	sed \
		-e '/GCC_FLAGS/ s:-g::' \
		-e 's:VALA_API_GEN:VAPIGEN:g' \
		-i configure || die

}

src_configure() {
	gnome2_src_configure \
		$(use_enable debug trace-log) \
		$(use_enable icu) \
		$(use_enable introspection) \
		$(use_enable static-libs static) \
		$(use_enable test tests)
}

src_install() {
	gnome2_src_install

	if use examples ; then
		insinto /usr/share/doc/${PN}/
		doins -r examples
	fi

	if use introspection ; then
		install_gi_override() {
			python_moduleinto "$(python_get_sitedir)/gi/overrides"
			python_domodule "${S}"/bindings/python/Dee.py
		}
		python_foreach_impl install_gi_override
	fi
}
