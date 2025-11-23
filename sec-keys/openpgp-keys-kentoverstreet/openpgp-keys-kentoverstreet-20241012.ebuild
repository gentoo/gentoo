# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Kent Overstreet"
HOMEPAGE="https://bcachefs.org/"
SRC_URI="https://git.kernel.org/pub/scm/docs/kernel/pgpkeys.git/plain/keys/13AB336D8DCA6E76.asc -> ${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm64"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - kentoverstreet.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
