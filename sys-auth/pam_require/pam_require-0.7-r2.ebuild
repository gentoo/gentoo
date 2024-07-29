# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools pam

DESCRIPTION="Allows you to require a special group or user to access a service"
HOMEPAGE="https://www.splitbrain.org/projects/pam_require"
SRC_URI="https://www.splitbrain.org/_media/projects/pamrequire/${P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~x86"

DEPEND="sys-libs/pam"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P/_/-}

src_prepare() {
	default
	mv "${S}"/configure.in "${S}"/configure.ac || die "mv configure.in to configure.ac"
	eautoreconf
}

src_install() {
	dopammod pam_require.so

	einstalldocs
}
