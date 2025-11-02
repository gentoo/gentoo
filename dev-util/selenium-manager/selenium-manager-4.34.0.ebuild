# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

inherit cargo

TAG=selenium-${PV}
MY_P=selenium-${TAG}
CRATES_P=selenium-4.33.0
DESCRIPTION="CLI tool that manages the browser/driver infrastructure required by Selenium"
HOMEPAGE="
	https://www.selenium.dev/
	https://github.com/SeleniumHQ/selenium/
"
SRC_URI="
	https://github.com/SeleniumHQ/selenium/archive/selenium-${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+="
		https://github.com/gentoo-crate-dist/selenium/releases/download/${CRATES_P}/${CRATES_P}-crates.tar.xz
	"
fi
S="${WORKDIR}/${MY_P}/rust"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD ISC MIT MPL-2.0 Unicode-3.0 Unicode-DFS-2016"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv ~x86"
IUSE="telemetry test"
RESTRICT="!test? ( test )"

DEPEND="
	app-arch/bzip2:=
	app-arch/xz-utils:=
	app-arch/zstd:=
	sys-libs/zlib:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	test? (
		|| (
			www-client/firefox
			www-client/firefox-bin
		)
	)
"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare() {
	default

	sed -i -e '/strip/d' Cargo.toml || die
	if ! use telemetry; then
		sed -i -e '/avoid-stats/s:false:true:' src/config.rs || die
	fi

	# Avoid tests requiring Internet or specific browsers (or trying
	# to fetch them, whatever).
	rm tests/browser_download_tests.rs || die
	rm tests/cache_tests.rs || die
	rm tests/electron_tests.rs || die
	rm tests/exec_driver_tests.rs || die
	rm tests/grid_tests.rs || die
	rm tests/browser_tests.rs || die
	rm tests/config_tests.rs || die
	rm tests/iexplorer_tests.rs || die
	rm tests/mirror_tests.rs || die
	rm tests/output_tests.rs || die
	rm tests/stable_browser_tests.rs || die
	rm tests/webview_tests.rs || die

	# enable system libraries where supported
	export ZSTD_SYS_USE_PKG_CONFIG=1
	sed -i -e '/features.*static/d' "${ECARGO_VENDOR}"/apple-xar-*/Cargo.toml || die

	# remove unbundled sources, just in case
	# (smoke.c is actually used to test system -lz, sigh)
	find "${ECARGO_VENDOR}"/*-sys-*/ \
		\( -name '*.c' -a -not -name 'smoke.c' \) -delete || die

	# bzip2-sys requires a pkg-config file
	# https://github.com/alexcrichton/bzip2-rs/issues/104
	mkdir "${T}/pkg-config" || die
	export PKG_CONFIG_PATH=${T}/pkg-config${PKG_CONFIG_PATH+:${PKG_CONFIG_PATH}}
	cat >> "${T}/pkg-config/bzip2.pc" <<-EOF || die
		Name: bzip2
		Version: 9999
		Description:
		Libs: -lbz2
	EOF
}

src_test() {
	local -x PATH=${T}/bin:${PATH}

	mkdir "${T}/bin" || die
	if ! has_version "www-client/firefox"; then
		# upstream expects "firefox" rather than "firefox-bin"
		ln -s "$(type -P firefox-bin)" "${T}/bin/firefox" || die
	fi

	cargo_src_test --no-fail-fast
}

src_install() {
	cargo_src_install
	einstalldocs
	dodoc README.md

	newenvd - 70selenium-manager <<-EOF || die
		SE_MANAGER_PATH="${EPREFIX}/usr/bin/selenium-manager"
	EOF
}
