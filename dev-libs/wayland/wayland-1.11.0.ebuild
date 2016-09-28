# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="git://anongit.freedesktop.org/git/${PN}/${PN}"
	GIT_ECLASS="git-r3"
	EXPERIMENTAL="true"
	AUTOTOOLS_AUTORECONF=1
fi

inherit autotools-multilib toolchain-funcs $GIT_ECLASS

DESCRIPTION="Wayland protocol libraries"
HOMEPAGE="https://wayland.freedesktop.org/"

if [[ $PV = 9999* ]]; then
	SRC_URI="${SRC_PATCHES}"
	KEYWORDS="alpha amd64 arm hppa x86"
else
	SRC_URI="https://wayland.freedesktop.org/releases/${P}.tar.xz"
	KEYWORDS="alpha amd64 arm hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="doc static-libs"

RDEPEND=">=dev-libs/expat-2.1.0-r3:=[${MULTILIB_USEDEP}]
	>=virtual/libffi-3.0.13-r1:=[${MULTILIB_USEDEP}]
	dev-libs/libxml2:="
DEPEND="${RDEPEND}
	doc? (
		>=app-doc/doxygen-1.6[dot]
		app-text/xmlto
		>=media-gfx/graphviz-2.26.0
		sys-apps/grep[pcre]
	)
	virtual/pkgconfig"

multilib_src_configure() {
	local myeconfargs=(
		$(multilib_native_use_enable doc documentation)
		$(multilib_native_enable dtd-validation)
	)
	if tc-is-cross-compiler ; then
		myeconfargs+=( --with-host-scanner )
	fi

	autotools-utils_src_configure
}

src_test() {
	export XDG_RUNTIME_DIR="${T}/runtime-dir"
	mkdir "${XDG_RUNTIME_DIR}" || die
	chmod 0700 "${XDG_RUNTIME_DIR}" || die

	autotools-multilib_src_test
}
