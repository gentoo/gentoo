# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Lexmark universal printer driver PPDs"
HOMEPAGE="https://www.lexmark.com/en_us/support/universal-print-driver.html"
SRC_URI="https://downloads.lexmark.com/downloads/drivers/Lexmark-UPD-PPD-Files.tar.Z -> ${P}.tar.Z"
RESTRICT="mirror"

LICENSE="Lexmark-EU2-0111"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="
	>=net-print/cups-1.4
	net-dns/avahi
"
BDEPEND=""

# TODO: add IUSE for foomatic and install those files too

S="${WORKDIR}"/ppd_files

QA_FLAGS_IGNORED="usr/libexec/cups/filter/LexCommandFileFilterG2"

src_prepare() {
	default
	sed -i 's:/usr/lib/cups/filter/:/usr/libexec/cups/filter/:g' GlobalPPD_1.4/Lexmark_UPD_Series.ppd || die "Unable to patch hard coded PPD paths"
}

src_install() {
	local filterdir
	if use amd64; then filterdir="lib64";
	elif use x86; then filterdir="lib";
	else die "No filter for architecture"; fi

	insinto /usr/share/cups/model
	exeinto /usr/libexec/cups/filter

	doins "${S}"/GlobalPPD_1.4/Lexmark_UPD_Series.ppd
	doexe "${S}"/GlobalPPD_1.4/$filterdir/LexCommandFileFilterG2
	doexe "${S}"/GlobalPPD_1.4/LexFaxPnHFilter
}
