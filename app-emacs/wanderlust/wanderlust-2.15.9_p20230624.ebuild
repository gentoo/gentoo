# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Yet Another Message Interface on Emacsen"
HOMEPAGE="https://github.com/wanderlust/wanderlust"
GITHUB_SHA1="8369b2d5170a174652294835dd9a18ed21a38cb2"
SRC_URI="https://github.com/wanderlust/${PN}/archive/${GITHUB_SHA1}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${GITHUB_SHA1}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~ppc64 x86"
IUSE="bbdb ssl l10n_ja"

RDEPEND=">=app-emacs/apel-10.8
	>=app-emacs/flim-1.14.9
	>=app-emacs/semi-1.14.7
	bbdb? ( app-emacs/bbdb )"
DEPEND="${RDEPEND}"

ELISP_REMOVE="
	tests/test-dist.el
	tests/test-rfc2368.el
"

SITEFILE="50${PN}-gentoo.el"

src_configure() {
	local lang="\"en\""
	use l10n_ja && lang="${lang} \"ja\""
	echo "(setq wl-info-lang '(${lang}) wl-news-lang '(${lang}))" >>WL-CFG
	use ssl && echo "(setq wl-install-utils t)" >>WL-CFG
}

src_compile() {
	emake all info PACKAGE_LISPDIR="NONE"
}

src_test() {
	emake test PACKAGE_LISPDIR="NONE"
}

src_install() {
	emake \
		LISPDIR="${ED}${SITELISP}" \
		PACKAGE_LISPDIR="NONE" \
		PIXMAPDIR="${ED}${SITEETC}/wl/icons" \
		install

	elisp-site-file-install "${FILESDIR}/${SITEFILE}" wl

	insinto "${SITEETC}/wl/samples/en"
	doins samples/en/*
	doinfo doc/wl*.info
	dodoc BUGS ChangeLog* INSTALL NEWS README.md

	if use l10n_ja; then
		insinto "${SITEETC}/wl/samples/ja"
		doins samples/ja/*
		dodoc BUGS.ja INSTALL.ja NEWS.ja README.ja.md
	fi
}
