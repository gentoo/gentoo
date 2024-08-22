# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp readme.gentoo-r1

MY_PN="${PN%-*}-emacs"
DESCRIPTION="Zenburn color theme for Emacs"
HOMEPAGE="https://github.com/bbatsov/zenburn-emacs"
SRC_URI="https://github.com/bbatsov/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"

src_install() {
	insinto "${SITEETC}/${PN}"
	doins zenburn-theme.el

	local sha256=$(sha256sum zenburn-theme.el) || die
	sed "s:@SHA256@:${sha256%% *}:" "${FILESDIR}/${SITEFILE}" \
		> "${T}/${SITEFILE}" || die
	elisp-site-file-install "${T}/${SITEFILE}"

	dodoc CHANGELOG.md CONTRIBUTING.md README.md
	dodoc -r screenshots
	docompress -x /usr/share/doc/${PF}/screenshots

	local DOC_CONTENTS="To enable zenburn by default, initialise it
		in your ~/.emacs:
		\n\t(load-theme 'zenburn)"
	readme.gentoo_create_doc
}
