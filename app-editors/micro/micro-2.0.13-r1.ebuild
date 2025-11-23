# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module optfeature desktop xdg

DESCRIPTION="Modern and intuitive terminal-based text editor"
HOMEPAGE="https://github.com/zyedidia/micro"
SRC_URI="https://github.com/zyedidia/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="MIT Apache-2.0 BSD MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

BDEPEND="dev-vcs/git"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.12-no-strip.patch
)

src_compile() {
	# We build/install this way for bug #915628 (highlighting)
	emake VERSION=${PV} build
}

src_install() {
	dodir /usr/bin
	emake VERSION=${PV} GOBIN="${ED}"/usr/bin install
	doman ./assets/packaging/micro.1
	domenu assets/packaging/micro.desktop
	einstalldocs
}

pkg_postinst() {
	# Update desktop file mime cache
	xdg_pkg_postinst

	optfeature_header "Clipboard support with display servers:"
	optfeature "Xorg" x11-misc/xsel x11-misc/xclip
	optfeature "Wayland" gui-apps/wl-clipboard
}
