# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by eduVPN developers"
HOMEPAGE="https://www.eduvpn.org/"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"

src_install() {
	insinto /usr/share/openpgp-keys
	newins - eduvpn.asc <<-EOF
		-----BEGIN PGP PUBLIC KEY BLOCK-----

		mDMEY/9MXBYJKwYBBAHaRw8BAQdA2bC0zO381EeJPHYwKva61bmsosc6fyKq23jM
		NdxZ7bq0PmVkdVZQTiBMaW51eCBBcHAgUmVwb3NpdG9yeSBTaWduaW5nIEtleSA8
		YXBwK2xpbnV4QGVkdXZwbi5vcmc+iJkEExYKAEEWIQQif/P4+CnZqTFNnroCu4BI
		u/8iLAUCY/9MXAIbAwUJEswDAAULCQgHAgIiAgYVCgkICwIEFgIDAQIeBwIXgAAK
		CRACu4BIu/8iLI2ZAP97myPuZLwtrN+o+JF0p/3CNihR6zRJOpmwF091xOcqtgEA
		iDrsQULCIxmesTPXRYW/mainxUgYXaF4GQpGTGOXowk=
		=Qpnp
		-----END PGP PUBLIC KEY BLOCK-----
	EOF
}
