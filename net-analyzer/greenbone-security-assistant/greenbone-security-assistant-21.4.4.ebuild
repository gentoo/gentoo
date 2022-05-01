# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake systemd toolchain-funcs

MY_PN="gsad"

DESCRIPTION="Greenbone Security Assistant"
HOMEPAGE="https://www.greenbone.net/en/ https://github.com/greenbone/gsa"
SRC_URI="https://github.com/greenbone/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="extras"

DEPEND="
	acct-group/gvm
	acct-user/gvm
	dev-libs/libgcrypt:0=
	dev-libs/libxml2
	dev-libs/libxslt
	>=net-analyzer/gvm-libs-21.4.1
	net-libs/gnutls:=
	net-libs/libmicrohttpd"

RDEPEND="
	${DEPEND}
	~net-analyzer/greenbone-security-assistant-${PV}
	>=net-analyzer/gvmd-21.4.1
	net-analyzer/ospd-openvas"

BDEPEND="
	dev-python/polib
	virtual/pkgconfig
	extras? (
		app-doc/doxygen[dot]
		app-doc/xmltoman
		app-text/htmldoc
		sys-devel/gettext
	)"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	cmake_src_prepare
	# QA-Fix | Remove !CLANG doxygen warnings for 9.0.0
	if use extras; then
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
}

src_configure() {
	local mycmakeargs=(
		"-DLOCALSTATEDIR=${EPREFIX}/var"
		"-DSYSCONFDIR=${EPREFIX}/etc"
		"-DSBINDIR=${EPREFIX}/usr/bin"
		"-DDEFAULT_CONFIG_DIR=${EPREFIX}/etc/default"
		"-DLOGROTATE_DIR=${EPREFIX}/etc/logrotate.d"
		"-DGSAD_RUN_DIR=${EPREFIX}/run/gvmd"
	)
	cmake_src_configure
}

src_compile() {
	if use extras; then
		cmake_build -C "${BUILD_DIR}" doc
		cmake_build doc-full -C "${BUILD_DIR}" doc
	fi
	cmake_build rebuild_cache
}

src_install() {
	if use extras; then
		local HTML_DOCS=( "${BUILD_DIR}/doc/generated/html/." )
	fi
	cmake_src_install

	insinto /etc/gvm/sysconfig
	doins "${FILESDIR}/${MY_PN}-daemon.conf"

	insinto /etc/gvm/reverse-proxy
	doins "${FILESDIR}/gsa.nginx.reverse.proxy.example"
	fowners -R gvm:gvm /etc/gvm

	newinitd "${FILESDIR}/${MY_PN}-${PV}.init" "${MY_PN}"
	newconfd "${FILESDIR}/${MY_PN}-daemon.conf" "${MY_PN}"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${MY_PN}.logrotate" "${MY_PN}"

	systemd_dounit "${FILESDIR}/${MY_PN}.service"

	rm -r "${D}/run" || die
}
