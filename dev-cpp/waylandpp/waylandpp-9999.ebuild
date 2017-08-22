# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib scons-utils toolchain-funcs versionator

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
	S="${WORKDIR}/waylandpp-${PV}"
fi

COMMON_DEPEND="
	>=dev-libs/wayland-1.11.0
	media-libs/mesa[wayland]
"
DEPEND="${COMMON_DEPEND}
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
	"
RDEPEND="${COMMON_DEPEND}"

src_compile() {
	CC="$(tc-getCXX)" PKG_CONFIG="$(tc-getPKG_CONFIG)" escons
	if use doc; then
		doxygen || die "error making docs"
	fi
}

src_install() {
	PREFIX="${D%/}/usr" scons install
	# fix multilib-strict QA failures
	mv "${ED%/}"/usr/{lib,$(get_libdir)} || die
	if use doc; then
		doman doc/man/man3/*.3
		HTML_DOCS="doc/html" einstalldocs
	fi
}
