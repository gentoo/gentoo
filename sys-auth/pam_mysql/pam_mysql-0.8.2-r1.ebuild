# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools pam

DESCRIPTION="pam_mysql is a module for pam to authenticate users with mysql"
HOMEPAGE="https://github.com/NigelCunningham/pam-MySQL"
SRC_URI="https://github.com/NigelCunningham/pam-MySQL/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/pam-MySQL-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="openssl"

DEPEND="
	>=sys-libs/pam-0.72:0=
	dev-db/mysql-connector-c:0=
	virtual/libcrypt:=
	openssl? ( dev-libs/openssl:0= )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-pam-mods-dir="$(getpam_mod_dir)"
		$(use_with openssl)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
