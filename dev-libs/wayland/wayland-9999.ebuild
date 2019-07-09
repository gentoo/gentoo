# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/wayland/wayland.git"
	inherit git-r3
else
	SRC_URI="https://wayland.freedesktop.org/releases/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi
inherit autotools libtool multilib-minimal toolchain-funcs

DESCRIPTION="Wayland protocol libraries"
HOMEPAGE="https://wayland.freedesktop.org/ https://gitlab.freedesktop.org/wayland/wayland"

LICENSE="MIT"
SLOT="0"
IUSE="doc static-libs"

BDEPEND="
	virtual/pkgconfig
	doc? (
		>=app-doc/doxygen-1.6[dot]
		app-text/xmlto
		>=media-gfx/graphviz-2.26.0
		sys-apps/grep[pcre]
	)
"
DEPEND="
	>=dev-libs/expat-2.1.0-r3:=[${MULTILIB_USEDEP}]
	dev-libs/libxml2:=
	>=virtual/libffi-3.0.13-r1:=[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}
	!<media-libs/mesa-18.1.1-r1
"

src_prepare() {
	default
	[[ $PV = 9999* ]] && eautoreconf || elibtoolize
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-static
		$(multilib_native_use_enable doc documentation)
		$(multilib_native_enable dtd-validation)
	)
	tc-is-cross-compiler && myeconfargs+=( --with-host-scanner )

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	find "${D}" -name '*.la' -delete || die
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
