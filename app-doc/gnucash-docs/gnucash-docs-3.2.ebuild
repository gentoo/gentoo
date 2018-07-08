# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="C de it ja pt ru"
PLOCALE_BACKUP="C"

inherit autotools gnome2 l10n

DESCRIPTION="Documentation package for GnuCash"
HOMEPAGE="http://www.gnucash.org/"
SRC_URI="https://github.com/Gnucash/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2 FDL-1.1"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

for my_locale in ${PLOCALES}; do
	IUSE+=" l10n_${my_locale}"
done

DEPEND="
	app-text/docbook-xml-dtd
	app-text/docbook-xsl-stylesheets
	app-text/rarian
	dev-libs/libxml2
	dev-libs/libxslt
"

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	:
}

src_install() {
	local doc_type lang

	for doc_type in help guide ; do
		for lang in $(l10n_get_locales); do
			cd "${S}/${doc_type}/${lang}" || die
			emake DESTDIR="${D}" install
		done
	done

	cd "${S}" || die
	einstalldocs
}

pkg_postinst() {
	gnome2_pkg_postinst
	has_version dev-java/fop || elog "You need dev-java/fop to generate pdf files."
	has_version gnome-extra/yelp || elog "You need gnome-extra/yelp to view the docs."
}
