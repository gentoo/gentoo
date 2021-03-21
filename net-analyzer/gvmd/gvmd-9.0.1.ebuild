# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake flag-o-matic systemd toolchain-funcs

DESCRIPTION="Greenbone vulnerability manager, previously named openvas-manager"
HOMEPAGE="https://www.greenbone.net/en/"
SRC_URI="https://github.com/greenbone/gvmd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="extras test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-db/postgresql:*[uuid]
	dev-libs/libgcrypt:0=
	dev-libs/libical
	>=net-analyzer/gvm-libs-11.0.1
	net-libs/gnutls:=[tools]
	extras?   (
		app-text/xmlstarlet
		dev-texlive/texlive-latexextra )"

RDEPEND="
	${DEPEND}
	acct-user/gvm
	net-analyzer/ospd-openvas"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	extras? (
		app-doc/doxygen[dot]
		app-doc/xmltoman
		app-text/htmldoc
		dev-libs/libxslt
	)
	test? ( dev-libs/cgreen )"

PATCHES=(
	# Replace deprecated glibc sys_siglist with strsignal
	"${FILESDIR}/${P}-glibc_siglist.patch"
)

src_prepare() {
	cmake_src_prepare
	# QA-Fix | Use correct FHS/Gentoo policy paths for 9.0.0
	sed -i -e "s*share/doc/gvm/html/*share/doc/gvmd-${PV}/html/*g" "$S"/doc/CMakeLists.txt || die
	sed -i -e "s*/doc/gvm/*/doc/gvmd-${PV}/*g" "$S"/CMakeLists.txt || die
	# QA-Fix | Remove !CLANG Doxygen warnings for 9.0.0
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
		"-DLIBDIR=${EPREFIX}/usr/$(get_libdir)"
		"-DSBINDIR=${EPREFIX}/usr/bin"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use extras; then
		cmake_build -C "${BUILD_DIR}" doc
		cmake_build doc-full -C "${BUILD_DIR}" doc
	fi
	if use test; then
		cmake_build tests
	fi
	cmake_build rebuild_cache
}

src_install() {
	if use extras; then
		local HTML_DOCS=( "${BUILD_DIR}"/doc/generated/html/. )
	fi
	cmake_src_install

	insinto /etc/gvm
	doins -r "${FILESDIR}"/*sync*

	insinto /etc/gvm/sysconfig
	doins "${FILESDIR}/${PN}-daemon.conf"

	exeinto /etc/gvm
	doexe "${FILESDIR}"/gvmd-startpre.sh

	fowners -R gvm:gvm /etc/gvm

	newinitd "${FILESDIR}/${PN}.init" "${PN}"
	newconfd "${FILESDIR}/${PN}-daemon.conf" "${PN}"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" "${PN}"

	systemd_dounit "${FILESDIR}/${PN}.service"

	# Set proper permissions on required files/directories
	keepdir /var/lib/gvm/gvmd
	fowners -R gvm:gvm /var/lib/gvm
}
