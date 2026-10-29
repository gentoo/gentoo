# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""
RUST_MIN_VER="1.88.0"

inherit cargo

DESCRIPTION="Proxy for using WebDriver clients to interact with Gecko-based browsers"
HOMEPAGE="https://firefox-source-docs.mozilla.org/testing/geckodriver/ https://github.com/mozilla/geckodriver"
SRC_URI="https://github.com/mozilla/geckodriver/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-crate-dist/geckodriver/releases/download/v${PV}/${P}-crates.tar.xz"

LICENSE="MPL-2.0"
# Dependent crate licenses
LICENSE+="
	MIT MPL-2.0 Unicode-3.0
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~riscv x86"

IUSE="unchained"

RDEPEND="!www-client/firefox[geckodriver(-)]"

pkg_setup() {
	QA_FLAGS_IGNORED="/usr/$(get_libdir)/firefox/geckodriver"
	rust_pkg_setup
}

src_prepare() {
	# Apply the unchained patch from https://github.com/rafiibrahim8/geckodriver-unchained -
	# makes geckodriver available on Gecko-based non-Firefox browsers, e.g. Librewolf.
	# bgo#930568
	use unchained && eapply "${FILESDIR}"/geckodriver-0.34.0-firefox-125.0-unchained.patch

	default
}

src_install() {
	einstalldocs

	mkdir -p "${D}"/usr/$(get_libdir)/firefox || die "Failed to create /usr/lib*/firefox directory."
	exeinto /usr/$(get_libdir)/firefox
	doexe "$(cargo_target_dir)"/geckodriver
	dosym -r /usr/$(get_libdir)/firefox/geckodriver /usr/bin/geckodriver
}
