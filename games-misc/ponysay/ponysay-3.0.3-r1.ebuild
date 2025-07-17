# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} python3_13t )
inherit edo python-single-r1

DESCRIPTION="cowsay reimplemention for ponies"
HOMEPAGE="https://github.com/erkin/ponysay"
SRC_URI="https://github.com/erkin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~m68k ~x86"
IUSE="doc +non-free"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
BDEPEND="${PYTHON_DEPS}
	doc? ( sys-apps/texinfo )
"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.3-python-syntax.patch"
	"${FILESDIR}/${PN}-3.0.3-pr313.patch"
)

setup_py() {
	local args=(
		--prefix="${EPREFIX}"/usr
		--everything
		--without-info-compression
		--without-man-compression
		--without-pdf-compression
		--without-shared-cache
		--freedom=$(usex non-free no yes)
		--with-bash-completion
		--with-fish-completion
		--with-zsh-completion
		$(use_with doc info)
		$(use_with doc pdf "${EPREFIX}"/usr/share/doc/${PF})
		"${@}"
	)
	edo "${PYTHON}" setup.py "${args[@]}"
}

src_compile() {
	setup_py build
}

src_install() {
	setup_py --destdir="${D}" prebuilt

	python_fix_shebang "${ED}"/usr/bin/${PN}

	rm -rv "${ED}"/usr/share/licenses || die
	dodoc CHANGELOG CONTRIBUTING CREDITS README.md
	sed -e 's/ponysay-tool-tool/ponysay-tool/g' -i "${ED}"/usr/share/bash-completion/completions/ponysay-tool || die
}
