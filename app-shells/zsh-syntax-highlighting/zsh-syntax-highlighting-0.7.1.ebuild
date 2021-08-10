# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1

if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/zsh-users/${PN}.git"
	inherit git-r3
else
	MY_PV=$(ver_rs 3 -)
	SRC_URI="https://github.com/zsh-users/zsh-syntax-highlighting/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="Fish shell like syntax highlighting for zsh"
HOMEPAGE="https://github.com/zsh-users/zsh-syntax-highlighting"

LICENSE="BSD"
SLOT="0"

RDEPEND="app-shells/zsh"

DISABLE_AUTOFORMATTING="true"
DOC_CONTENTS="In order to use ${CATEGORY}/${PN} add
. /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh
at the end of your ~/.zshrc"

src_prepare() {
	sed -i -e 's/COPYING.md//' Makefile || die
	default
}

src_install() {
	emake \
		SHARE_DIR="${ED}/usr/share/zsh/site-functions" \
		DOC_DIR="${ED}/usr/share/doc/${PF}" \
		install
	readme.gentoo_create_doc
}
