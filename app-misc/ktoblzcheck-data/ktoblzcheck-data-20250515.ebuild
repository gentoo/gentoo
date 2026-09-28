# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

LIB_PN="ktoblzcheck"

inherit cmake python-any-r1

DESCRIPTION="Up to date bankdata information in several formats for ktoblzcheck"
HOMEPAGE="https://ktoblzcheck.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${LIB_PN}/${P}.tar.gz"

# Bundesbank: https://www.bundesbank.de/de/aufgaben/unbarer-zahlungsverkehr/serviceangebot/bankleitzahlen/download---bankleitzahlen-602592
SRC_URI+=" https://www.bundesbank.de/resource/blob/602632/bec25ca5df1eb62fefadd8325dafe67c/472B63F073F071307366337C94F8C870/blz-aktuell-txt-data.txt
	-> ${P}-blz-aktuell-txt-data.txt"

# Betaalvereniging Nederland
SRC_URI+=" https://www.betaalvereniging.nl/wp-content/uploads/BIC-lijst-NL-2.xlsx -> ${P}-nl_data.xlsx"

# SEPA
SRC_URI+=" http://bundesbank.de/scl-directory -> ${P}-sepa.csv"

# Six Group: https://github.com/MicrosoftDocs/dynamics365smb-docs/blob/main/business-central/LocalFunctionality/Switzerland/how-to-import-swiss-bank-clearing-numbers.md?
SRC_URI+=" https://api.six-group.com/api/epcd/bankmaster/v3/bankmaster_V3.csv -> ${P}-ch_data.txt"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

BDEPEND="
	${PYTHON_DEPS}
	dev-db/sqlite
"

DOCS=( README.md )

src_unpack() {

	unpack ${P}.tar.gz

	# Copy bank data
	LABEL="`/bin/date --iso-8601`"
	cp -v "${DISTDIR}/${P}-blz-aktuell-txt-data.txt" "${S}/data/blz_${LABEL}.txt" || die
	cp -v "${DISTDIR}/${P}-nl_data.xlsx" "${S}/data/nl_data.xlsx" || die
	cp -v "${DISTDIR}/${P}-ch_data.txt" "${S}/data/ch_data.txt" || die
	cp -v "${DISTDIR}/${P}-sepa.csv" "${S}/data/sepa_${LABEL}.txt" || die
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_BANKDATA_DOWNLOAD=OFF
		-DINSTALL_RAW_BANKDATA_FILE=ON
		-DINSTALL_SEPA_BANKDATA_FILE=ON
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# Install additional files
	insinto "/usr/share/${LIB_PN}"
	doins "${S}/data/ch_data.txt"
}
