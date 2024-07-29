# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1

if [[ "${PV}" = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zsh-users/${PN}.git"
else
	SRC_URI="https://github.com/zsh-users/zsh-syntax-highlighting/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"
fi

DESCRIPTION="Fish shell like syntax highlighting for zsh"
HOMEPAGE="https://github.com/zsh-users/zsh-syntax-highlighting"

LICENSE="BSD"
SLOT="0"

RDEPEND="app-shells/zsh"

DISABLE_AUTOFORMATTING="true"

DOC_CONTENTS="\
In order to use ${CATEGORY}/${PN}, add
\`source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh\`
at the end of your ~/.zshrc"

src_prepare() {
	default

	sed -i "s/COPYING.md//" Makefile || die
}

src_install() {
	emake \
		SHARE_DIR="${ED}/usr/share/zsh/site-functions" \
		DOC_DIR="${ED}/usr/share/doc/${PF}" \
		install

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
