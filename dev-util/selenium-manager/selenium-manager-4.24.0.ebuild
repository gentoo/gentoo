# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

inherit cargo

TAG=selenium-${PV}
MY_P=selenium-${TAG}
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
		https://dev.gentoo.org/~mgorny/dist/${P}-crates.tar.xz
	"
fi
S="${WORKDIR}/${MY_P}/rust"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD ISC MIT MPL-2.0 Unicode-DFS-2016"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="telemetry test"
RESTRICT="!test? ( test )"

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
	rm tests/exec_driver_tests.rs || die
	rm tests/grid_tests.rs || die
	rm tests/browser_tests.rs || die
	rm tests/config_tests.rs || die
	rm tests/iexplorer_tests.rs || die
	rm tests/mirror_tests.rs || die
	rm tests/stable_browser_tests.rs || die
	rm tests/webview_tests.rs || die
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
