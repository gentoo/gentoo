# Copyright 1999-2019 Gentoo Authors
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

my_l10n_get_locales() {
	local l locales
	for l in ${PLOCALES[@]}; do
		use "l10n_${l}" && locales+=( $l )
	done
	if [[ ${#locales[@]} -gt 0 ]]; then
		echo ${locales[@]}
	else
		echo $PLOCALE_BACKUP
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	:
}

src_install() {
	local doc_type my_lang

	for doc_type in help guide; do
		for my_lang in $(my_l10n_get_locales); do
			case $my_lang in
				# Both help and guides translated
				C|de|it|pt) ;;
				ru|ja) # Only guides translated
					if [[ ${doc_type} = "help" ]] ; then
						elog "Help documentation hasn't been translated for $my_lang"
						elog "Will do English instead."
						my_lang=C
					fi
					;;
				*)
					die "Invalid locale: $my_lang"
					;;
			esac

			cd "${S}/${doc_type}/${my_lang}" || die
			emake DESTDIR="${D}" install
		done
	done

	cd "${S}" || die
	einstalldocs
}

pkg_postinst() {
	gnome2_pkg_postinst
	optfeature "You need dev-java/fop to generate pdf files." dev-java/fop
	optfeature "You need gnome-extra/yelp to view the docs." gnome-extra/yelp
}
