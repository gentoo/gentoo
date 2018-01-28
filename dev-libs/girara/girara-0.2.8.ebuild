# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib toolchain-funcs virtualx
[[ ${PV} == 9999* ]] && inherit git-2

DESCRIPTION="UI library that focuses on simplicity and minimalism"
HOMEPAGE="http://pwmt.org/projects/girara/"
if ! [[ ${PV} == 9999* ]]; then
SRC_URI="http://pwmt.org/projects/${PN}/download/${P}.tar.gz"
fi
EGIT_REPO_URI="https://git.pwmt.org/pwmt/${PN}.git"
EGIT_BRANCH="develop"

LICENSE="ZLIB"
SLOT="3"
if ! [[ ${PV} == 9999* ]]; then
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
fi
IUSE="libnotify static-libs test"

RDEPEND=">=dev-libs/glib-2.28
	>=x11-libs/gtk+-3.4:3
	dev-libs/json-c
	!<${CATEGORY}/${PN}-0.1.6
	libnotify? ( >=x11-libs/libnotify-0.7 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	test? ( x11-apps/xhost
		dev-libs/check )"

pkg_setup() {
	mygiraraconf=(
		WITH_LIBNOTIFY=$(usex libnotify 1 0)
		PREFIX="${EPREFIX}"/usr
		LIBDIR='${PREFIX}'/$(get_libdir)
		CC="$(tc-getCC)"
		SFLAGS=''
		VERBOSE=1
		DESTDIR="${D}"
		)
}

src_prepare() {
	# Remove 'static' and 'install-static' targets
	if ! use static-libs; then
		sed -i \
			-e '/^${PROJECT}:/s:static::' \
			-e '/^install:/s:install-static::' \
			Makefile || die
	fi
}

src_compile() {
	emake "${mygiraraconf[@]}"
}

src_test() {
	virtx default
}

src_install() {
	emake "${mygiraraconf[@]}" install
	dodoc AUTHORS
}
