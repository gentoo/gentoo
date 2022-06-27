# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake systemd toolchain-funcs

DESCRIPTION="Greenbone vulnerability manager, previously named openvas-manager"
HOMEPAGE="https://www.greenbone.net https://github.com/greenbone/gvmd/"
SRC_URI="https://github.com/greenbone/gvmd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="AGPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="
	acct-group/gvm
	acct-user/gvm
	app-crypt/gpgme:1=
	dev-db/postgresql:*[uuid]
	dev-libs/glib:2
	dev-libs/libical:=
	>=net-analyzer/gvm-libs-21.4.4
	net-libs/gnutls:=[tools]
"
# gvmd (optionally) uses xml_split from XML-Twig at runtime. And texlive
# and xmlstartlet are used for (PDF) report generator at runtime.
RDEPEND="
	${DEPEND}
	app-text/xmlstarlet
	dev-perl/XML-Twig
	dev-texlive/texlive-latexextra
	net-analyzer/ospd-openvas
"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	doc? (
		app-doc/doxygen[dot]
		app-doc/xmltoman
		app-text/htmldoc
		dev-libs/libxslt
	)
	test? ( dev-libs/cgreen )
"

src_prepare() {
	cmake_src_prepare
	# QA-Fix | Use correct FHS/Gentoo policy paths for 9.0.0
	sed -i -e "s*share/doc/gvm/html/*share/doc/${PF}/html/*g" doc/CMakeLists.txt || die
	sed -i -e "s*/doc/gvm/*/doc/${PF}/*g" CMakeLists.txt || die
	# QA-Fix | Remove !CLANG Doxygen warnings for 9.0.0
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

	# https://github.com/greenbone/gvmd/pull/1819
	sed -i "/^EnvironmentFile/d" config/gvmd.service.in || die

	# Upstream 3ebab6044818f1710b73c04e94fd9bea148c9853
	sed -i \
		-e 's/^RuntimeDirectory=gvm/RuntimeDirectory=gvmd/' \
		-e 's/GVM_RUN_DIR/GVMD_RUN_DIR/' \
		config/gvmd.service.in || die

	# https://github.com/greenbone/gvmd/pull/1824
	sed -i '/^install (DIRECTORY DESTINATION ${GVMD_RUN_DIR})/d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		"-DLOCALSTATEDIR=${EPREFIX}/var"
		"-DSYSCONFDIR=${EPREFIX}/etc"
		"-DLIBDIR=${EPREFIX}/usr/$(get_libdir)"
		"-DSBINDIR=${EPREFIX}/usr/bin"
		"-DSYSTEMD_SERVICE_DIR=$(systemd_get_systemunitdir)"
		"-DGVM_DEFAULT_DROP_USER=gvm"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use doc; then
		cmake_build -C "${BUILD_DIR}" doc
		cmake_build doc-full -C "${BUILD_DIR}" doc
	fi
	if use test; then
		cmake_build tests
	fi
	cmake_build rebuild_cache
}

src_install() {
	if use doc; then
		local HTML_DOCS=( "${BUILD_DIR}"/doc/generated/html/. )
	fi
	cmake_src_install

	insinto /etc/gvm/sysconfig
	doins "${FILESDIR}/${PN}-daemon.conf"
	if ! use prefix; then
		fowners -R gvm:gvm /etc/gvm
	fi

	newinitd "${FILESDIR}/${P}.init" "${PN}"
	newconfd "${FILESDIR}/${PN}-daemon.conf" "${PN}"

	# Set proper permissions on required files/directories
	keepdir /var/lib/gvm/gvmd
	if ! use prefix; then
		fowners -R gvm:gvm /var/lib/gvm
	fi

	dosbin "${FILESDIR}"/gvm-sync-all
	systemd_dounit "${FILESDIR}"/gvm-sync-all.{service,timer}
}
