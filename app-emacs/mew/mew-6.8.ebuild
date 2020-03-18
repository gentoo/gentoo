# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
NEED_EMACS=24

inherit elisp readme.gentoo-r1

DESCRIPTION="Great MIME mail reader for Emacs/XEmacs"
HOMEPAGE="https://www.mew.org/"
SRC_URI="https://www.mew.org/Release/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="ssl l10n_ja"
RESTRICT="test"

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}
	ssl? ( net-misc/stunnel )"

SITEFILE="50${PN}-gentoo.el"

src_configure() {
	econf \
		--with-elispdir="${SITELISP}/${PN}" \
		--with-etcdir="${SITEETC}/${PN}"
}

src_compile() {
	emake
	use l10n_ja && emake jinfo
	rm -f info/*~				# remove spurious backup files
}

src_install() {
	emake DESTDIR="${D}" install
	use l10n_ja && emake DESTDIR="${D}" install-jinfo
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc 00api 00changes* 00diff 00readme dot.*

	DOC_CONTENTS="Please refer to /usr/share/doc/${PF} for sample
		configuration files."
	readme.gentoo_create_doc
}
