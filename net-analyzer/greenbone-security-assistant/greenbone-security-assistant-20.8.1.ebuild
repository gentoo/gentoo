# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake flag-o-matic systemd toolchain-funcs

MY_PN="gsa"
MY_DN="gsad"
MY_NODE_N="node_modules"

DESCRIPTION="Greenbone Security Assistant"
HOMEPAGE="https://www.greenbone.net/en/ https://github.com/greenbone/gsa"
SRC_URI="https://github.com/greenbone/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/greenbone/${MY_PN}/releases/download/v${PV}/gsa-node-modules-${PV}.tar.gz -> ${P}-${MY_NODE_N}.tar.gz"

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
	>=net-analyzer/gvm-libs-20.8.0
	net-libs/gnutls:=
	net-libs/libmicrohttpd"

RDEPEND="
	${DEPEND}
	>=net-analyzer/gvmd-20.8.0
	net-analyzer/ospd-openvas"

BDEPEND="
	dev-python/polib
	>=net-libs/nodejs-8.12.0
	>=sys-apps/yarn-1.15.2
	virtual/pkgconfig
	extras? (
		app-doc/doxygen[dot]
		app-doc/xmltoman
		app-text/htmldoc
		sys-devel/gettext
	)"

BUILD_DIR="${WORKDIR}/${MY_PN}-${PV}_build"
S="${WORKDIR}/${MY_PN}-${PV}"
MY_NODE_DIR="${S}/${MY_PN}/"

PATCHES=(
	# Disable yarn-fetch during compile.
	# AND Remove ugly uninstall-snippet that causes failing re-emerge.
	"${FILESDIR}/${P}-node.patch"
)

src_prepare() {
	cmake_src_prepare
	# We will use pre-generated npm stuff.
	mv "${WORKDIR}/${MY_NODE_N}" "${MY_NODE_DIR}" || die "couldn't move node_modules"
	# Update .yarnrc accordingly.
	echo "--modules-folder ${MY_NODE_DIR}" >> "${S}/${MY_PN}/.yarnrc" || die "echo failed"
	# QA-Fix | Remove !CLANG doxygen warnings for 9.0.0
	if use extras; then
		if ! tc-is-clang; then
		   local f
		   for f in gsad/doc/*.in
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
		"-DGSAD_PID_DIR=${EPREFIX}/run/"
		"-DDEFAULT_CONFIG_DIR=${EPREFIX}/etc/default"
		"-DLOGROTATE_DIR=${EPREFIX}/etc/logrotate.d"
	)
	cmake_src_configure
}

src_compile() {
	# setting correct PATH for finding react-js
	NODE_ENV=production PATH="$PATH:${S}/gsa/node_modules/.bin/" cmake_src_compile
	if use extras; then
		cmake_build -C "${BUILD_DIR}" doc
		cmake_build doc-full -C "${BUILD_DIR}" doc
	fi
	cmake_build rebuild_cache
}

src_install() {
	if use extras; then
		local HTML_DOCS=( "${BUILD_DIR}/${MY_DN}/doc/generated/html/." )
	fi
	cmake_src_install

	insinto /etc/gvm/sysconfig
	doins "${FILESDIR}/${MY_DN}-daemon.conf"

	insinto /etc/gvm/reverse-proxy
	doins "${FILESDIR}/${MY_PN}.nginx.reverse.proxy.example"
	fowners -R gvm:gvm /etc/gvm

	newinitd "${FILESDIR}/${MY_DN}.init" "${MY_DN}"
	newconfd "${FILESDIR}/${MY_DN}-daemon.conf" "${MY_DN}"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${MY_DN}.logrotate" "${MY_DN}"

	systemd_dounit "${FILESDIR}/${MY_DN}.service"
}
