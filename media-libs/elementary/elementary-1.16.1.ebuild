# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

MY_P=${P/_/-}

if [[ "${PV}" == "9999" ]] ; then
	EGIT_SUB_PROJECT="core"
	EGIT_URI_APPEND="${PN}"
else
	SRC_URI="https://download.enlightenment.org/rel/libs/${PN}/${MY_P}.tar.xz"
	EKEY_STATE="snap"
fi

inherit enlightenment

DESCRIPTION="Basic widget set, based on EFL for mobile touch-screen devices"
HOMEPAGE="https://trac.enlightenment.org/e/wiki/Elementary"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-interix ~x86-solaris ~x64-solaris"

LICENSE="LGPL-2.1"
IUSE="debug examples fbcon quicklaunch sdl wayland X static-libs"

DEPEND=">=dev-libs/efl-${PV}[fbcon?,sdl?,png,wayland?,X?]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	E_ECONF=(
		$(use_enable debug)
		$(use_enable doc)
		--disable-ecore-cocoa
		--disable-ecore-psl1ght
		--disable-ecore-win32
		--disable-elocation
		--disable-emap
		--disable-eweather
		# broken: make[4]: *** No rule to make target 'prefs_example_01.epb', needed by 'all-am'.  Stop
		#$(use_enable examples build-examples)
		$(use_enable examples install-examples)
		$(use_enable fbcon ecore-fb)
		$(use_enable sdl ecore-sdl)
		$(use_enable wayland ecore-wayland)
		$(use_enable X ecore-x)
		$(use_enable quicklaunch quick-launch)
	)

	enlightenment_src_configure
}
