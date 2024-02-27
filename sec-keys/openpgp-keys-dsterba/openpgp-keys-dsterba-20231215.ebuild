# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KEYRING_COMMIT="cb054da9bd0aafde33ec7b73709de2db3e383ca0"

DESCRIPTION="OpenPGP keys used by David Sterba"
HOMEPAGE="https://github.com/jpakkane"
SRC_URI="https://git.kernel.org/pub/scm/docs/kernel/pgpkeys.git/plain/keys/C565D5F9D76D583B.asc?id=${KEYRING_COMMIT} -> ${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86"

src_install() {
	insinto /usr/share/openpgp-keys
	newins "${DISTDIR}"/${P}.asc ${PN##openpgp-keys-}.asc
}
