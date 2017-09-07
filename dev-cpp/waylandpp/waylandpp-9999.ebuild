# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit scons-utils toolchain-funcs versionator

DESCRIPTION="Wayland C++ bindings"
HOMEPAGE="https://github.com/NilsBrause/waylandpp"

LICENSE="MIT"
IUSE="doc"
SLOT="0/$(get_major_version)"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/NilsBrause/waylandpp.git"
	inherit git-r3
else
	SRC_URI="https://github.com/NilsBrause/waylandpp/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

RDEPEND="
	>=dev-libs/wayland-1.11.0
	media-libs/mesa[wayland]
"
DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
	"

src_compile() {
	CC="$(tc-getCXX)" PKG_CONFIG="$(tc-getPKG_CONFIG)" ROOT="${D%/}/" PREFIX="/usr" LIBDIR="$(get_libdir)" escons
	if use doc; then
		doxygen || die "error making docs"
	fi
}

src_install() {
	CC="$(tc-getCXX)" PKG_CONFIG="$(tc-getPKG_CONFIG)" ROOT="${D%/}/" PREFIX="/usr" LIBDIR="$(get_libdir)" escons install
	# fix multilib-strict QA failures
	if use doc; then
		doman doc/man/man3/*.3
		local HTML_DOCS=( doc/html )
		einstalldocs
	fi
}
