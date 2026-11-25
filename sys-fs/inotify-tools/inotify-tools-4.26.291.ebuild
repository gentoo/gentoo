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

	# skip tests that require elevated privileges
	rm t/fsnotifywait-errors.t || die
}

src_compile() {
	cargo_src_compile

	INOTIFY_EMAKEARGS=(
		CARGO=: # handled by cargo_src_compile instead
		OUT="$(cargo_target_dir)"
		ENABLE_STATIC=0
		prefix="${EPREFIX}"/usr
		libdir="${EPREFIX}"/usr/$(get_libdir)
		docdir="${EPREFIX}"/usr/share/doc/${PF}
	)

	emake "${INOTIFY_EMAKEARGS[@]}" headers man $(usev doc)
}

src_test() {
	cargo_src_test

	emake "${INOTIFY_EMAKEARGS[@]}" {unit,integration}-test
}

src_install() {
	emake "${INOTIFY_EMAKEARGS[@]}" DESTDIR="${D}" \
		install $(usev doc install-doc)

	dodoc AUTHORS ChangeLog README.md
}
