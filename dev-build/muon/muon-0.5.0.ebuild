# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A meson-compatible build system"
HOMEPAGE="https://muon.build/"
SRC_URI="
	https://muon.build/releases/v${PV}/${PN}-v${PV}.tar.gz
	https://muon.build/releases/v${PV}/docs/man.tar.gz -> ${P}-man.tar.gz
"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+archive +curl +libpkgconf test"

DEPEND="
	curl? ( net-misc/curl )
	archive? ( app-arch/libarchive:= )
	libpkgconf? ( dev-util/pkgconf:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	test? ( dev-util/gdbus-codegen )
"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}"-0.5.0-workaround-meson-15093.patch
)

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
		-Dman-pages=disabled
		-Dmeson-docs=disabled
		-Dtracy=disabled    # not in repos
		-Dsamurai=disabled  # patched version of samurai downloaded via wraps
		-Dreadline=bestline # small vendored dependency
		-Dwebsite=disabled  # unneeded
		-Dui=disabled       # too many vendored depdendencies

		# Pulled into the right directory above.
		$(meson_feature test meson-tests)
	)
	meson_src_configure
}

src_install() {
	meson_install

	einstalldocs
	doman "${WORKDIR}/man/muon.1"
	doman "${WORKDIR}/man/meson.build.5"
}
