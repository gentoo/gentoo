# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false"
PVCUT=$(ver_cut 1-2)
inherit ecm frameworks.kde.org

DESCRIPTION="Tools to generate documentation in various formats from DocBook files"

LICENSE="MIT"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="nls"

BDEPEND="
	dev-lang/perl
	dev-perl/URI
	nls? ( >=kde-frameworks/ki18n-${PVCUT}:5 )
"
DEPEND="
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	app-text/sgml-common
	dev-libs/libxml2:2
	dev-libs/libxslt
	=kde-frameworks/karchive-${PVCUT}*:5
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-5.54.0-gentoo-docbundledir.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package nls KF5I18n)
	)

	ecm_src_configure
}

src_test() {
	# bug 665622
	local myctestargs=(
		-E "(kdoctools_install)"
	)

	ecm_src_test
}
