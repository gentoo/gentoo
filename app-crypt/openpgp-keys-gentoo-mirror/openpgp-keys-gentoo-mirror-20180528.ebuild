# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="OpenPGP key used to sign gentoo-mirror commits"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Repository_mirror_and_CI"
SRC_URI="https://dev.gentoo.org/~mgorny/dist/openpgp-keys/gentoo-mirror.asc.${PV}.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

S=${WORKDIR}

src_install() {
	insinto /usr/share/openpgp-keys
	newins "gentoo-mirror.asc.${PV}" gentoo-mirror.asc
}
