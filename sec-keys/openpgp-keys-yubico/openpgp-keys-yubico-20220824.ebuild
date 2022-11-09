# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Yubico's developers"
HOMEPAGE="https://developers.yubico.com/Software_Projects/Software_Signing.html"
# Current keys. Keys which should also be there but as of 2022-08-24 trigger import failures
# due to having no user IDs associated with them on the keyserver:
#  - Tommaso De Orchi <tom@yubico.com> (0x1CE39268A0973948)
#  - Jean Paul Galea <jeanpaul@yubico.com> (0xFF8D3B45B7B875A9)
#  - Trevor Bentley <trevor@yubico.com> (0x8CED3A80D41C0DCB)
#  - Pedro Martelletto <pedro@yubico.com> (0xB428949EF7914718)
SRC_URI="
	https://keys.openpgp.org/vks/v1/by-fingerprint/0A3B0262BCA1705307D5FF06BCA00FD4B2168C0A
		-> yubico-0A3B0262BCA1705307D5FF06BCA00FD4B2168C0A.asc
	https://keys.openpgp.org/vks/v1/by-fingerprint/20EE325B86A81BCBD3E56798F04367096FBA95E8
		-> yubico-20EE325B86A81BCBD3E56798F04367096FBA95E8.asc
	https://keys.openpgp.org/vks/v1/by-fingerprint/B70D62AA6A31AD6B9E4F9F4BDC8888925D25CA7A
		-> yubico-B70D62AA6A31AD6B9E4F9F4BDC8888925D25CA7A.asc
	https://keys.openpgp.org/vks/v1/by-fingerprint/57A9DEED4C6D962A923BB691816F3ED99921835E
		-> yubico-57A9DEED4C6D962A923BB691816F3ED99921835E.asc
	https://keys.openpgp.org/vks/v1/by-fingerprint/1D7308B0055F5AEF36944A8F27A9C24D9588EA0F
		-> yubico-1D7308B0055F5AEF36944A8F27A9C24D9588EA0F.asc
	https://keys.openpgp.org/vks/v1/by-fingerprint/355C8C0186CC96CBA49F9CD8DAA17C2953914D9D
		-> yubico-355C8C0186CC96CBA49F9CD8DAA17C2953914D9D.asc
	https://keys.openpgp.org/vks/v1/by-fingerprint/9E885C0302F9BB9167529C2D5CBA11E6ADC7BCD1
		-> yubico-9E885C0302F9BB9167529C2D5CBA11E6ADC7BCD1.asc
	https://keys.openpgp.org/vks/v1/by-fingerprint/7FBB6186957496D58C751AC20E777DD85755AA4A
		-> yubico-7FBB6186957496D58C751AC20E777DD85755AA4A.asc
	https://keys.openpgp.org/vks/v1/by-fingerprint/78D997D53E9C0A2A205392ED14A19784723C9988
		-> yubico-78D997D53E9C0A2A205392ED14A19784723C9988.asc
	https://keys.openpgp.org/vks/v1/by-fingerprint/AF511D2CBC0F973E5D308054325C8E4AE2E6437D
		-> yubico-AF511D2CBC0F973E5D308054325C8E4AE2E6437D.asc
"
# Old keys. Keys which should also be there but as of 2022-08-24 trigger import failures
# due to having no user IDs associated with them on the keyserver:
#  - Simon Josefsson <simon@yubico.com> (0x0664A76954265E8C)
#  - Henrik Strath <henrik@yubico.com> (0x9EA90242958E0658)
SRC_URI+="
	https://keys.openpgp.org/vks/v1/by-fingerprint/8D0B4EBA9345254BCEC0E843514F078FF4AB24C3
		-> yubico-8D0B4EBA9345254BCEC0E843514F078FF4AB24C3.asc
	https://keys.openpgp.org/vks/v1/by-fingerprint/1DC4BA2872525B3F2FE8207F5D9C760A3FB51707
		-> yubico-1DC4BA2872525B3F2FE8207F5D9C760A3FB51707.asc
"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - yubico.com.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
