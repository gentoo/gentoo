# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit elisp-common vcs-snapshot

EGIT_COMMIT="28e36bac97dc8ed089bac409bef15f1831b6adde"

DESCRIPTION="SKK utilities to manage dictionaries"
HOMEPAGE="http://openlab.jp/skk/"
SRC_URI="https://github.com/skk-dev/skktools/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="emacs"

RDEPEND="dev-libs/glib:2
	sys-libs/gdbm
	emacs? ( virtual/emacs )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( ChangeLog README.md )
SITEFILE="50${PN}-gentoo.el"

src_configure() {
	econf --with-gdbm
}

src_compile() {
	default

	if use emacs; then
		elisp-compile *.el
	fi
}

src_install() {
	default
	dodoc READMEs/*

	local d
	for d in convert2skk filters; do
		newdoc ${d}/README.md README.${d}
		rm -f ${d}/README.md
	done

	insinto /usr/share/${PN}
	doins *.awk *.scm
	rm -rf convert2skk/obsolete
	doins -r convert2skk filters

	if use emacs; then
		elisp-install ${PN} *.el{,c}
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
