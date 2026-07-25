# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Key isn't in a convenient format to download
# https://gdal.org/en/stable/download.html#current-release

SEC_KEYS_VALIDPGPKEYS=(
	# openpgp GDPR policy strikes again. Dont use it
	"7B130E955B44D87CCE2765F0DBD81FF52EC2A42A:gdal:ubuntu,manual"
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used to sign GDAL"
HOMEPAGE="https://gdal.org"

KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"

src_compile() {
	# hack
	A="${A} ${FILESDIR}/gdal-${PV}.gpg" sec-keys_src_compile
}
