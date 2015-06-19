# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/smarty-docs/smarty-docs-3.0.ebuild,v 1.6 2014/08/10 21:05:45 slyfox Exp $

EAPI=4

KEYWORDS="~alpha amd64 hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="pdf html"
DESCRIPTION="Documentation for Smarty, a template engine for PHP"
HOMEPAGE="http://www.smarty.net/documentation"
SRC_URI="html? ( http://www.smarty.net/files/docs/manual-en-${PV}.zip -> ${P}-en.zip )
	pdf? ( http://www.smarty.net/files/docs/manual-en-${PV}.pdf -> ${P}-en.pdf )"

LANGS="en"

for X in ${LANGS}; do
	[[ ${X} != "en" ]] && SRC_URI="${SRC_URI} linguas_${X}? (
		html? ( http://www.smarty.net/files/docs/manual-${X}-${PV}.zip -> ${P}-${X}.zip )
		pdf? ( http://www.smarty.net/files/docs/manual-${X}-${PV}.pdf -> ${P}-${X}.pdf ) )"
	IUSE="${IUSE} linguas_${X}"
done

LICENSE="LGPL-2.1"
SLOT="0"

DEPEND="html? ( app-arch/unzip )"
RDEPEND="${DEPEND}"

REQUIRED_USE="|| ( html pdf )"

src_unpack() {
	mkdir -p "${S}"

	if use html; then
		mkdir "${S}"/html
		pushd "${S}"/html > /dev/null

		unpack ${P}-en.zip

		for X in ${LANGS}; do
			if [[ ${X} != "en" ]] && use linguas_${X}; then
				unpack ${P}-${X}.zip
			fi
		done

		popd > /dev/null
	fi
}

src_install() {
	if use html; then
		dohtml -r html/*
	fi

	if use pdf; then
		docinto pdf
		dodoc "${DISTDIR}"/${P}-*.pdf
	fi
}
