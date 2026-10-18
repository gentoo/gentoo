# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo

DESCRIPTION="Set of command-line programs providing a simple interface to inotify"
HOMEPAGE="https://github.com/inotify-tools/inotify-tools/"
SRC_URI="
	https://github.com/inotify-tools/inotify-tools/releases/download/${PV}/${P}.tar.gz
	https://distfiles.gentoo.org/pub/dev/ionen@gentoo.org/${P}-vendor.tar.xz
"

LICENSE="GPL-2+"
LICENSE+=" || ( Apache-2.0 MIT )" # crates
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc64 ~riscv ~sparc ~x86"
IUSE="doc"

BDEPEND="
	doc? ( app-text/doxygen )
"

QA_FLAGS_IGNORED="
	usr/bin/inotifywait
	usr/bin/inotifywatch
	usr/lib.*/libinotifytools.*
"

src_prepare() {
	default

	sed -i '/lto = true/d' Cargo.toml || die
}

src_compile() {
	cargo_src_compile

	emake headers man $(usev doc)
}

src_test() {
	cargo_src_test

	emake {unit,integration}-test
}

src_install() {
	local emakeargs=(
		CARGO_TARGET_DIR="$(cargo_target_dir)"
		DESTDIR="${D}"
		ENABLE_STATIC=0
		prefix="${EPREFIX}"/usr
		libdir="${EPREFIX}"/usr/$(get_libdir)
		docdir="${EPREFIX}"/usr/share/doc/${PF}
	)

	emake "${emakeargs[@]}" install $(usev doc install-doc)

	dodoc AUTHORS ChangeLog README.md
}
