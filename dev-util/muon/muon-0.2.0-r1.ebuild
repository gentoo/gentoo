# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit meson python-any-r1

COMMIT_HASH="${PV}"
MESON_DOCS_TAR=meson-docs-0.64.1-19-g39c6fa4bc.tar.gz

DESCRIPTION="A meson-compatible build system"
HOMEPAGE="https://muon.build/"
SRC_URI="
	https://git.sr.ht/~lattis/muon/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz
	man? (
		https://mochiro.moe/wrap/${MESON_DOCS_TAR}
	)
"

# Apache-2.0 for meson-docs
LICENSE="GPL-3 man? ( Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64"
IUSE="+archive +curl +libpkgconf +man"

S="${WORKDIR}/${PN}-${COMMIT_HASH}"

DEPEND="
	curl? ( net-misc/curl )
	archive? ( app-arch/libarchive:= )
	libpkgconf? ( dev-util/pkgconf:= )
	man? ( app-text/scdoc )
"
RDEPEND="${DEPEND}"
BDEPEND="
	man? (
		$(python_gen_any_dep '
			dev-python/pyyaml[${PYTHON_USEDEP}]
		')
	)
"

python_check_deps() {
	python_has_version "dev-python/pyyaml[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use man && python-any-r1_pkg_setup
}

src_prepare() {
	default

	if use man; then
		mv "${WORKDIR}/meson-docs" "${S}/subprojects" || die
	fi
}

src_configure() {
	local emesonargs=(
		$(meson_feature curl libcurl)
		$(meson_feature archive libarchive)
		$(meson_feature libpkgconf)
		$(meson_feature man docs)
		-Dsamurai=disabled  # patched version of samurai downloaded via wraps
		-Dbestline=enabled  # vendored bestline, an insignificant addition
	)
	meson_src_configure
}
