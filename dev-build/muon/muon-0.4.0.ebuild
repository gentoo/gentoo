# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo meson

MESON_TESTS_HASH=1e565931348f15f3f9b654f46ab4bf5fa009ca4f
MESON_TESTS_DIRNAME="meson-tests-${MESON_TESTS_HASH}"

DESCRIPTION="A meson-compatible build system"
HOMEPAGE="https://muon.build/"
SRC_URI="
	https://muon.build/releases/v${PV}/${PN}-v${PV}.tar.gz
	test? (
		 https://git.sr.ht/~lattis/meson-tests/archive/${MESON_TESTS_HASH}.tar.gz
			-> ${MESON_TESTS_DIRNAME}.tar.gz
	)
"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~sparc"
IUSE="+archive +curl +libpkgconf test"

DEPEND="
	curl? ( net-misc/curl )
	archive? ( app-arch/libarchive:= )
	libpkgconf? ( dev-util/pkgconf:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	app-text/scdoc
	test? ( dev-util/gdbus-codegen )
"
RESTRICT="!test? ( test )"

src_unpack() {
	default

	if use test; then
		edo mv "${WORKDIR}/${MESON_TESTS_DIRNAME}" \
			"${S}"/tests/project/meson-tests
	fi
}

src_prepare() {
	default
}

src_configure() {
	cat >"${T}/program-file.ini" <<-EOF
	[binaries]
	git = 'if this exists youre a bad person'
	EOF
	local emesonargs=(
		--native-file="${T}/program-file.ini"
		$(meson_feature curl libcurl)
		$(meson_feature archive libarchive)
		$(meson_feature libpkgconf)
		-Ddocs=enabled
		-Dtracy=disabled    # not in repos
		-Dsamurai=disabled  # patched version of samurai downloaded via wraps
		-Dreadline=bestline # small vendored dependency
	)
	meson_src_configure
}
