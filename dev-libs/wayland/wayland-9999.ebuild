# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="git://anongit.freedesktop.org/git/wayland/${PN}"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
fi

inherit autotools libtool ltprune multilib-minimal toolchain-funcs $GIT_ECLASS

DESCRIPTION="Wayland protocol libraries"
HOMEPAGE="https://wayland.freedesktop.org/"

if [[ $PV = 9999* ]]; then
	SRC_URI=""
else
	SRC_URI="https://wayland.freedesktop.org/releases/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
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

src_prepare() {
	default
	[[ $PV = 9999* ]] && eautoreconf || elibtoolize
}

multilib_src_configure() {
	local myconf
	if tc-is-cross-compiler ; then
		myconf+=' --with-host-scanner '
	fi

	ECONF_SOURCE="${S}" econf \
		--disable-static \
		$(multilib_native_use_enable doc documentation) \
		$(multilib_native_enable dtd-validation) \
		${myconf}
}

multilib_src_install_all() {
	prune_libtool_files
	einstalldocs
}

src_test() {
	# We set it on purpose to only a short subdir name, as socket paths are
	# created in there, which are 108 byte limited. With this it hopefully
	# barely fits to the limit with /var/tmp/portage/$CAT/$PF/temp/xdr
	export XDG_RUNTIME_DIR="${T}"/xdr
	mkdir "${XDG_RUNTIME_DIR}" || die
	chmod 0700 "${XDG_RUNTIME_DIR}" || die

	multilib-minimal_src_test
}
