# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs xdg-utils

DESCRIPTION="A monitor of resources"
HOMEPAGE="https://github.com/aristocratos/btop"
SRC_URI="https://github.com/aristocratos/btop/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~m68k ~mips ~ppc ppc64 ~riscv x86"

PATCHES=(
	# Backported fixes for https://bugs.gentoo.org/884005,
	# can be removed in 1.2.14 or later
	"${FILESDIR}/${P}-fix-makefile-deps.patch"
	"${FILESDIR}/${P}-verbose-mkdir.patch"

	# Backported fix for https://bugs.gentoo.org/908670
	# can be removed in 1.2.14 or later
	"${FILESDIR}/${P}-musl-1.2.4-lfs64.patch"

	# Backported patch to allow compilation with clang 16 or above
	# can be removed in 1.2.14 or later
	"${FILESDIR}/${P}-allow-clang.patch"
)

pkg_setup() {
	if [[ "${MERGE_TYPE}" != "binary" ]]; then
		if tc-is-clang ; then
			if [[ "$(clang-major-version)" -lt 16 ]]; then
				die "sys-process/btop requires >=sys-devel/clang-16.0.0 to build."
			fi
		elif ! tc-is-gcc ; then
			die "$(tc-getCXX) is not a supported compiler. Please use sys-devel/gcc or >=sys-devel/clang-16.0.0 instead."
		fi
	fi
}

src_prepare() {
	default
	# btop installs README.md to /usr/share/btop by default
	sed -i '/^.*cp -p README.md.*$/d' Makefile || die
}

src_compile() {
	# Disable btop optimization flags, since we have our flags in CXXFLAGS
	emake VERBOSE=true OPTFLAGS="" CXX="$(tc-getCXX)"
}

src_install() {
	emake \
		PREFIX="${EPREFIX}/usr" \
		DESTDIR="${D}" \
		install

	dodoc README.md CHANGELOG.md
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
