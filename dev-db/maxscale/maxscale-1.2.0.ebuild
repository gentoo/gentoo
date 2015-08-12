# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils cmake-utils multilib user

MY_PN="MaxScale"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A content aware, plug-able MySQL proxy server"
HOMEPAGE="http://mariadb.com/MaxScale"
SRC_URI="https://github.com/mariadb-corporation/${MY_PN}/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="jemalloc rabbitmq tcmalloc"

REQUIRED_USE="?? ( jemalloc tcmalloc )"

DEPEND="
	dev-libs/libaio
	>=dev-libs/libpcre-8.35
	dev-libs/openssl:0
	net-misc/curl
	virtual/mysql[embedded]
	jemalloc? ( dev-libs/jemalloc )
	rabbitmq? ( net-libs/rabbitmq-c )
	tcmalloc? ( dev-util/google-perftools:= )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/${PN}-1.2.0-rpath.patch" )

pkg_setup() {
	enewgroup maxscale
	enewuser maxscale -1 -1 -1 maxscale
}

src_configure() {
#		-DEMBEDDED_LIB=/usr/$(get_libdir)/mysql
	local mycmakeargs=(
		-DSTATIC_EMBEDDED=OFF
		-DWITH_SCRIPTS=OFF
		$(cmake-utils_use_with jemalloc JEMALLOC)
		$(cmake-utils_use_build rabbitmq RABBITMQ)
		$(cmake-utils_use_with tcmalloc TCMALLOC)
		-DMODULE_INSTALL_PATH=$(get_libdir)/${PN}
	)
	cmake-utils_src_configure
}

src_install() {
	local DOCS=( README README.md "${BUILD_DIR}"/Changelog.txt "${BUILD_DIR}"/ReleaseNotes.txt )
	cmake-utils_src_install
	# Remove badly placed documents
	rm "${D}usr/share/${PN}/README" "${D}usr/share/${PN}/Changelog.txt" \
		"${D}usr/share/${PN}/LICENSE" "${D}usr/share/${PN}/COPYRIGHT" \
		"${D}usr/share/${PN}/ReleaseNotes.txt" || die
	newinitd "${FILESDIR}/${PN}-init.d" ${PN}
	keepdir /var/log/maxscale /var/lib/maxscale/data \
		/var/cache/maxscale
	fowners maxscale:maxscale /var/log/maxscale \
		/var/lib/maxscale/data \
		/var/lib/maxscale \
		/var/cache/maxscale
}
