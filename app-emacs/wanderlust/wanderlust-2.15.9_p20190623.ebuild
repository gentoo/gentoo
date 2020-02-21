# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Yet Another Message Interface on Emacsen"
HOMEPAGE="https://github.com/wanderlust/wanderlust"
GITHUB_SHA1="b9a529a54b9e7eafa4ed230ad28efffe0d25a20e"
SRC_URI="https://github.com/wanderlust/wanderlust/archive/${GITHUB_SHA1}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="bbdb ssl l10n_ja"

DEPEND=">=app-emacs/apel-10.8
	>=app-emacs/flim-1.14.9
	>=app-emacs/semi-1.14.7
	bbdb? ( app-emacs/bbdb )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${GITHUB_SHA1}"
SITEFILE="50${PN}-gentoo.el"

src_configure() {
	local lang="\"en\""
	use l10n_ja && lang="${lang} \"ja\""
	echo "(setq wl-info-lang '(${lang}) wl-news-lang '(${lang}))" >>WL-CFG
	use ssl && echo "(setq wl-install-utils t)" >>WL-CFG
}

src_compile() {
	emake
	emake info
}

src_install() {
	emake \
		LISPDIR="${ED}${SITELISP}" \
		PIXMAPDIR="${ED}${SITEETC}/wl/icons" \
		install

	elisp-site-file-install "${FILESDIR}/${SITEFILE}" wl

	insinto "${SITEETC}/wl/samples/en"
	doins samples/en/*
	doinfo doc/wl*.info
	dodoc BUGS ChangeLog INSTALL NEWS README.md

	if use l10n_ja; then
		insinto "${SITEETC}/wl/samples/ja"
		doins samples/ja/*
		dodoc BUGS.ja INSTALL.ja NEWS.ja README.ja
	fi
}
