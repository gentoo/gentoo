# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake systemd toolchain-funcs

DESCRIPTION="Greenbone Security Assistant"
HOMEPAGE="https://www.greenbone.net https://github.com/greenbone/gsad"
SRC_URI="https://github.com/greenbone/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="brotli doc"

DEPEND="
	acct-user/gvm
	>=net-libs/libmicrohttpd-0.9.0:=
	dev-libs/libxml2:2=
	>=dev-libs/glib-2.42:2
	>=net-analyzer/gvm-libs-22.8
	>=net-libs/gnutls-3.2.15:=
	>=sys-libs/zlib-1.2
	dev-libs/libgcrypt:0=
	brotli? (
		app-arch/brotli
	)
"

RDEPEND="
	${DEPEND}
	>=net-analyzer/gvmd-22.4
	>=net-analyzer/gsa-22.4
	net-analyzer/ospd-openvas
"

BDEPEND="
	dev-python/polib
	virtual/pkgconfig
	doc? (
		app-text/doxygen[dot]
		app-text/xmltoman
	)
"

src_prepare() {
	cmake_src_prepare

	# QA-Fix | Remove !CLANG doxygen warnings for 9.0.0
	if use doc; then
		if ! tc-is-clang; then
		   local f
		   for f in doc/*.in
		   do
			sed -i \
				-e "s*CLANG_ASSISTED_PARSING = NO*#CLANG_ASSISTED_PARSING = NO*g" \
				-e "s*CLANG_OPTIONS*#CLANG_OPTIONS*g" \
				"${f}" || die "couldn't disable CLANG parsing"
		   done
		fi
	fi

	# Avoid the use of brotli when not required by the use flag #942193
	# Remove brotli automagic dependencies check
	if ! use brotli; then
		sed -i \
			-e 's*^if (BROTLI_FOUND)*#if (BROTLI_FOUND)*' \
			-e 's*set (CMAKE_C_FLAGS            "${CMAKE_C_FLAGS} -DHAVE_BROTLI=1")*#set (CMAKE_C_FLAGS            "${CMAKE_C_FLAGS} -DHAVE_BROTLI=1")*' \
			-e 's*^endif (BROTLI_FOUND)*#endif (BROTLI_FOUND)*' \
			src/CMakeLists.txt || die "couldn't disable brotli automagic dependency's check"
	fi
}

src_configure() {
	local mycmakeargs=(
		"-DLOCALSTATEDIR=${EPREFIX}/var"
		"-DSYSCONFDIR=${EPREFIX}/etc"
		"-DSBINDIR=${EPREFIX}/usr/bin"
		"-DGSAD_RUN_DIR=${EPREFIX}/run/gsad"
		"-DGVMD_RUN_DIR=${EPREFIX}/run/gvmd"
		"-DGVM_LOG_DIR=${EPREFIX}/var/log/gvm"
		"-DSYSTEMD_SERVICE_DIR=$(systemd_get_systemunitdir)"
		"-DLOGROTATE_DIR=${EPREFIX}/etc/logrotate.d"
	)

	cmake_src_configure
}

src_compile() {
	# setting correct PATH for finding react-js
	NODE_ENV=production PATH="$PATH:${S}/gsa/node_modules/.bin/" cmake_src_compile
	if use doc; then
		cmake_build -C "${BUILD_DIR}" doc
		cmake_build doc-full -C "${BUILD_DIR}" doc
	fi
	cmake_build rebuild_cache
}

src_install() {
	if use doc; then
		local HTML_DOCS=( "${BUILD_DIR}/doc/generated/html/." )
	fi
	cmake_src_install

	systemd_install_serviced "${FILESDIR}/gsad.service.conf" \
			${PN}.service

	insinto /etc/gvm/sysconfig
	newins "${FILESDIR}/${PN}-daemon.conf" "${PN}-daemon.conf"

	newinitd "${FILESDIR}/${PN}-22.init" "${PN}"
	newconfd "${FILESDIR}/${PN}-daemon.conf" "${PN}"
}
