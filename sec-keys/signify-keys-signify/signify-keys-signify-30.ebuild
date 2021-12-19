# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN#signify-keys-}"
DESCRIPTION="Signify keys used to sign signify portable releases"
HOMEPAGE="https://github.com/aperezdc/signify"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_compile() {
	cat <<-EOF > ${MY_PN}-${SLOT}.pub
		untrusted comment: Signify portable release signing public key
		RWRQFCY809DUoWEHxWmoTNtxph6yUlWNsjfW54PqLI6S3dWfuZN4Ovj1
	EOF
}

src_install() {
	insinto /usr/share/signify-keys
	doins ${MY_PN}-${SLOT}.pub
}
