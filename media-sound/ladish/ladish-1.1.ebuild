# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE='threads(+)'

inherit python-single-r1 waf-utils

MY_P="${P}-g36c489e4"
DESCRIPTION="LADI Session Handler - a session management system for JACK applications"
HOMEPAGE="https://ladish.org"
SRC_URI="https://dl.ladish.org/ladish/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

# common/klist.h is linked list code borrowed from linux kernel, and thus is GPL2 only
# otherwise it is GPL-2+ code
LICENSE="GPL-2 GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

# media-sound/a2jmidid[dbus] is optional but recommended runtime-only dependency
IUSE="debug +lash +a2jmidid"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	dev-libs/expat
	media-sound/jack2[dbus]
	sys-apps/dbus
	virtual/jack
	${PYTHON_DEPS}
	a2jmidid? ( media-sound/a2jmidid[dbus] )
	lash? ( !!media-sound/lash )
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README.adoc )

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# libalsapid.so is version-less by upstream design
QA_SONAME=( ".*/libalsapid.so" )

src_configure() {
	local -a mywafconfargs=(
		$(usex debug --debug '')
		$(usex lash '--enable-liblash' '')
	)
	waf-utils_src_configure "${mywafconfargs[@]}"
}

src_install() {
	waf-utils_src_install

	if ! use a2jmidid; then
		rm "${ED}/usr/$(get_libdir)/libalsapid.so" || die
	fi
}
