# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

COMMIT_HASH="${PV}"
MESON_DOCS_TAR=meson-docs-0.64.1-19-g39c6fa4bc.tar.gz

DESCRIPTION="A meson-compatible build system"
HOMEPAGE="https://muon.build/"
SRC_URI="
	https://git.sr.ht/~lattis/muon/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz
"

# Apache-2.0 for meson-docs
LICENSE="GPL-3 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64"
IUSE="+archive +curl +libpkgconf"

S="${WORKDIR}/${PN}-${COMMIT_HASH}"

DEPEND="
	curl? ( net-misc/curl )
	archive? ( app-arch/libarchive:= )
	libpkgconf? ( dev-util/pkgconf:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	app-text/scdoc
"

src_prepare() {
	default
}

src_configure() {
	local emesonargs=(
		$(meson_feature curl libcurl)
		$(meson_feature archive libarchive)
		$(meson_feature libpkgconf)
		-Ddocs=enabled
		-Dsamurai=disabled  # patched version of samurai downloaded via wraps
		-Dbestline=enabled  # vendored bestline, an insignificant addition
	)
	meson_src_configure
}
