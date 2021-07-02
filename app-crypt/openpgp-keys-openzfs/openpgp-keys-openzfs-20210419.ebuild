# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used to sign OpenZFS releases"
HOMEPAGE="https://openzfs.github.io/openzfs-docs/"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc ~x86"

src_install() {
	local files=(
		 # Ned Bass (releases)
		"${FILESDIR}"/29D5610EAE2941E355A2FE8AB97467AAC77B9667-nedbass.asc
		# Tony Hutter (releases)
		"${FILESDIR}"/4F3BA9AB6D1F8D683DC2DFB56AD860EED4598027-tonyhutter.asc
		# Brian Behlendorf (master), but he signs RCs at least too
		"${FILESDIR}"/C33DF142657ED1F7C328A2960AB9E991C6AF658B-brianbehlendorf.asc
	)

	insinto /usr/share/openpgp-keys
	newins - openzfs.asc < <(cat "${files[@]}" || die)
}
