# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="onak is an OpenPGP keyserver"
HOMEPAGE="
	https://www.earth.li/projectpurple/progs/onak.html
	https://github.com/u1f35c/onak
"
SRC_URI="https://www.earth.li/projectpurple/files/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="berkdb +dynamic hkp postgres test"
REQUIRED_USE="test? ( dynamic )"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/nettle:=
	dev-libs/gmp:=
	berkdb? ( sys-libs/db:= )
	hkp? ( net-misc/curl )
	postgres? ( dev-db/postgresql:= )
"
DEPEND="${RDEPEND}"

DOCS=(
	README.md onak.sql
)

PATCHES=(
	"${FILESDIR}/${PN}-0.5.0-musl-strtouq-fix.patch"
	"${FILESDIR}/${P}-cmake.patch"
)

src_configure() {
	# variable is initialized with default values based on list from
	# keydb/CMakeLists.txt. The fs backend is the last one in the list for
	# USE=-dynamic backend options, see DBTYPE option, which mimics bahavior of
	# older ebuild version.
	local backends=( file keyring stacked keyd fs )
	use berkdb && backends+=( db4 )
	use hkp && backends+=( hkp )
	use postgres && backends+=( pg )
	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-DGENTOO_BACKENDS=$(IFS=';'; echo "${backends[*]}")
		-DDBTYPE=$(usex dynamic dynamic "${backends[-1]}")
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	keepdir /var/lib/onak
	insinto /usr/lib/cgi-bin/pks
	doins "${BUILD_DIR}"/cgi/{add,gpgwww,hashquery,lookup}
}
