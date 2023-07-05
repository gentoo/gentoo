# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake systemd toolchain-funcs
#
DESCRIPTION="Greenbone Security Assistant"
HOMEPAGE="https://www.greenbone.net https://github.com/greenbone/gsad"
SRC_URI="https://github.com/greenbone/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="AGPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	acct-user/gvm
	dev-libs/glib:2
	dev-libs/libgcrypt:0=
	dev-libs/libxml2
	dev-libs/libxslt
	>=net-analyzer/gvm-libs-${PV}
	net-libs/gnutls:=
	net-libs/libmicrohttpd:=
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
		app-doc/doxygen[dot]
		app-doc/xmltoman
		app-text/htmldoc
		sys-devel/gettext
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

	# Do not install the empty /run/gsad run dir. https://github.com/greenbone/gsad/pull/54
	sed -i "/^install.*GSAD_RUN_DIR/d" CMakeLists.txt || die

	# Drop Group= directive. https://github.com/greenbone/gsad/pull/55
	sed -i "/^Group=/d" config/gsad.service.in || die
}

src_configure() {
	local mycmakeargs=(
		"-DLOCALSTATEDIR=${EPREFIX}/var"
		"-DSYSCONFDIR=${EPREFIX}/etc"
		"-DSBINDIR=${EPREFIX}/usr/bin"
		"-DGSAD_RUN_DIR=${EPREFIX}/run/gsad"
		"-DGVMD_RUN_DIR=${EPREFIX}/run/gvmd"
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
	doins "${FILESDIR}/${PN}-daemon.conf"

	newinitd "${FILESDIR}/${PN}-22.init" "${PN}"
	newconfd "${FILESDIR}/${PN}-daemon.conf" "${PN}"
}
