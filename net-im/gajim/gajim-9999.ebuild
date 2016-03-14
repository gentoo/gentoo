# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
EHG_REPO_URI="https://hg.gajim.org/gajim"

PYTHON_COMPAT=( python3_{3,4,5} )
PYTHON_REQ_USE="sqlite,xml"

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils python-r1 versionator mercurial

MY_PV=${PV/_/-}
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Jabber client written in PyGTK"
HOMEPAGE="http://www.gajim.org/"

LICENSE="GPL-3"
SLOT="0"
IUSE="avahi crypt dbus gnome gnome-keyring kde idle jingle libnotify networkmanager nls spell +srv test X xhtml"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	libnotify? ( dbus )
	avahi? ( dbus )
	gnome? ( gnome-keyring )"

COMMON_DEPEND="
	${PYTHON_DEPS}
	x11-libs/gtk+:3"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40.1
	virtual/pkgconfig
	>=sys-devel/gettext-0.17-r1"
RDEPEND="${COMMON_DEPEND}
	dev-python/pyasn1[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.14[${PYTHON_USEDEP}]
	>=dev-python/python-nbxmpp-0.5.3[${PYTHON_USEDEP}]
	crypt? (
		app-crypt/gnupg
		dev-python/pycrypto[${PYTHON_USEDEP}]
		)
	dbus? (
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-libs/dbus-glib
		libnotify? ( dev-python/notify-python )
		avahi? ( net-dns/avahi[dbus,gtk,python,${PYTHON_USEDEP}] )
		)
	gnome? (
		dev-python/libgnome-python[${PYTHON_USEDEP}]
		dev-python/egg-python[${PYTHON_USEDEP}]
		)
	gnome-keyring? ( dev-python/gnome-keyring-python[${PYTHON_USEDEP}] )
	idle? ( x11-libs/libXScrnSaver )
	jingle? ( net-libs/farstream:0.2 )
	kde? ( kde-apps/kwalletmanager )
	networkmanager? (
			dev-python/dbus-python[${PYTHON_USEDEP}]
			net-misc/networkmanager
		)
	spell? ( app-text/gtkspell:2 )
	srv? (
		|| (
			dev-python/libasyncns-python[${PYTHON_USEDEP}]
			net-dns/bind-tools
			)
		)
	xhtml? ( dev-python/docutils[${PYTHON_USEDEP}] )"

RESTRICT="test"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	NO_AUTOTOOLS_RUN=1 ./autogen.sh
	eautoreconf
	python_copy_sources
}

src_configure() {
	configuration() {
		local myeconfargs=(
			$(use_enable nls)
			$(use_with X x)
			--docdir="/usr/share/doc/${PF}"
			--libdir="$(python_get_sitedir)"
			--enable-site-packages
		)
		run_in_build_dir autotools-utils_src_configure
	}
	python_foreach_impl configuration
}

src_compile() {
	compilation() {
		run_in_build_dir autotools-utils_src_compile
	}
	python_foreach_impl compilation
}

src_test() {
	testing() {
		run_in_build_dir ${PYTHON} test/runtests.py --verbose 3 || die
	}
	python_foreach_impl testing
}

src_install() {
	installation() {
		run_in_build_dir autotools-utils_src_install
		python_optimize
	}
	python_foreach_impl installation

	rm "${ED}/usr/share/doc/${PF}/README.html" || die
	dohtml README.html
}
