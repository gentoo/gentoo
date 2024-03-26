# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit bash-completion-r1 python-single-r1

DESCRIPTION="cowsay reimplemention for ponies"
HOMEPAGE="https://github.com/erkin/ponysay"
SRC_URI="https://github.com/erkin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~m68k ~x86"
IUSE="doc +non-free bash-completion fish-completion zsh-completion"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="${PYTHON_DEPS}
	doc? ( sys-apps/texinfo )"

RDEPEND="${PYTHON_DEPS}
	fish-completion? ( app-shells/fish )
	zsh-completion? ( app-shells/zsh )"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.3-python-syntax.patch"
	"${FILESDIR}/${PN}-3.0.3-pr313.patch"
)

setup_py() {
	"${PYTHON}" setup.py \
		--prefix="${EPREFIX}"/usr \
		--everything \
		--without-info-compression \
		--without-man-compression \
		--without-pdf-compression \
		--without-shared-cache \
		--freedom=$(usex non-free no yes) \
		$(use_with fish-completion) \
		$(use_with zsh-completion) \
		$(use_with doc info) \
		$(use_with doc pdf "${EPREFIX}"/usr/share/doc/${PF}) \
		"${@}" || die
}

src_compile() {
	setup_py \
		$(use_with bash-completion) \
		build
}

src_install() {
	setup_py \
		--without-bash-completion \
		--destdir="${D}" \
		prebuilt

	python_fix_shebang "${ED}"/usr/bin/${PN}

	rm -rv "${ED}"/usr/share/licenses || die
	dodoc CHANGELOG CONTRIBUTING CREDITS README.md

	use bash-completion &&
		newbashcomp completion/bash-completion.${PN}.install ${PN}
}
