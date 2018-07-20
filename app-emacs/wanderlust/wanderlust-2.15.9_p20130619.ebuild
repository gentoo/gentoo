# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="Yet Another Message Interface on Emacsen"
HOMEPAGE="https://github.com/wanderlust/wanderlust
	https://www.emacswiki.org/emacs/WanderLust"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="bbdb ssl l10n_ja"

DEPEND=">=app-emacs/apel-10.6
	virtual/emacs-flim
	app-emacs/semi
	bbdb? ( app-emacs/bbdb )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"
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
