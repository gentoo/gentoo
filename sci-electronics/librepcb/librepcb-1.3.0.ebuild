# Copyright 2009-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler2@2.0.0
	aho-corasick@1.1.3
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.6
	anstyle@1.0.10
	anyhow@1.0.94
	bitflags@2.6.0
	byteorder@1.5.0
	cbindgen@0.27.0
	cfg-if@1.0.0
	clap@4.5.22
	clap_builder@4.5.22
	clap_lex@0.7.3
	colorchoice@1.0.3
	crc32fast@1.4.2
	crossbeam-utils@0.8.20
	deranged@0.3.11
	equivalent@1.0.1
	errno@0.3.10
	fastrand@2.2.0
	flate2@1.0.35
	hashbrown@0.15.2
	heck@0.4.1
	indexmap@2.7.0
	interactive-html-bom@0.2.0
	is_terminal_polyfill@1.70.1
	itoa@1.0.14
	jzon@0.12.5
	libc@0.2.167
	linux-raw-sys@0.4.14
	log@0.4.22
	lz-str@0.2.1
	memchr@2.7.4
	miniz_oxide@0.8.0
	num-conv@0.1.0
	once_cell@1.20.2
	parameterized_test@0.2.1
	powerfmt@0.2.0
	proc-macro2@1.0.92
	quote@1.0.37
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	rustix@0.38.41
	ryu@1.0.18
	serde@1.0.215
	serde_derive@1.0.215
	serde_json@1.0.133
	serde_spanned@0.6.8
	strsim@0.11.1
	syn@2.0.90
	tempfile@3.14.0
	time-core@0.1.2
	time@0.3.37
	toml@0.8.19
	toml_datetime@0.6.8
	toml_edit@0.22.22
	unicode-ident@1.0.14
	utf8parse@0.2.2
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	winnow@0.6.20
	zip@0.6.6
"

inherit cargo cmake edo xdg

DESCRIPTION="Free EDA software to develop printed circuit boards"
HOMEPAGE="https://librepcb.org/"
SRC_URI="https://download.librepcb.org/releases/${PV}/${P}-source.zip
		  ${CARGO_CRATE_URIS}"
S="${WORKDIR}/${PN}-${PV/_/-}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="opencascade test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/muParser:=
	dev-qt/qtbase:6[concurrent,gui,network,opengl,sql,sqlite,ssl,widgets]
	dev-qt/qtdeclarative:6
	dev-qt/qtsvg:6
	media-libs/libglvnd[X]
	sys-libs/zlib
	virtual/glu
	opencascade? ( sci-libs/opencascade:= )"

DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"

BDEPEND="
	app-arch/unzip
	dev-qt/qttools:6[linguist]"

src_configure() {
	local mycmakeargs=(
		-DQT_MAJOR_VERSION=6
		-DUNBUNDLE_GTEST=ON
		-DUNBUNDLE_MUPARSER=ON
		-DUSE_OPENCASCADE=$(usex opencascade 1 0)
		-DBUILD_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}

src_test() {
	local -x QT_QPA_PLATFORM=offscreen
	cd "${BUILD_DIR}"/tests/unittests || die
	# https://github.com/LibrePCB/LibrePCB/issues/516
	edo ./librepcb-unittests --gtest_filter=-SystemInfoTest.testGetUsername:CategoryTreeModelTest.testSort:BoardPlaneFragmentsBuilderTest.testFragments:BoardGerberExportTest.test
}

pkg_postinst() {
	xdg_pkg_postinst

	ewarn
	ewarn "LibrePCB builds might not be exactly reproducible with e.g. -march={native,haswell,...}."
	ewarn "This can cause minor issues, see for example:"
	ewarn "https://github.com/LibrePCB/LibrePCB/issues/516"
	ewarn "For a completely reproducible build use: -march=x86-64."
	ewarn
}
