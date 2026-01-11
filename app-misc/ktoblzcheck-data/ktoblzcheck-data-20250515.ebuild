# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

LIB_PN="ktoblzcheck"

inherit cmake python-single-r1

DESCRIPTION="Up to date bankdata information in several formats for ktoblzcheck"
HOMEPAGE="https://ktoblzcheck.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${LIB_PN}/${P}.tar.gz"

# Bundesbank: https://www.bundesbank.de/de/aufgaben/unbarer-zahlungsverkehr/serviceangebot/bankleitzahlen/download---bankleitzahlen-602592
SRC_URI+=" https://www.bundesbank.de/resource/blob/602632/bec25ca5df1eb62fefadd8325dafe67c/472B63F073F071307366337C94F8C870/blz-aktuell-txt-data.txt"

# Six Group
SRC_URI+=" https://api.six-group.com/api/epcd/bankmaster/v2/public/downloads/bcbankenstamm -> ch_data.txt"

# Betaalvereniging Nederland
SRC_URI+=" https://www.betaalvereniging.nl/wp-content/uploads/BIC-lijst-NL-2.xlsx -> nl_data.xlsx"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="doc python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

BDEPEND="
	dev-python/openpyxl
	dev-db/sqlite
"

DOCS=( README.md )

src_unpack() {

	unpack ${P}.tar.gz

	# Copy bank data
	LABEL="`/bin/date --iso-8601`"
	cp -v "${DISTDIR}/blz-aktuell-txt-data.txt" "${S}/data/blz_${LABEL}.txt"
	cp -v "${DISTDIR}/ch_data.txt" "${S}/data/ch_data.txt"
	cp -v "${DISTDIR}/nl_data.xlsx" "${S}/data/nl_data.xlsx"
}

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
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
	install "${S}/data/ch_data.txt" "${ED}/usr/share/ktoblzcheck"
}
