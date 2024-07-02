# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false"
PVCUT=$(ver_cut 1-2)
inherit ecm frameworks.kde.org

DESCRIPTION="Tools to generate documentation in various formats from DocBook files"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="nls"

DEPEND="
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	app-text/sgml-common
	dev-libs/libxml2:2
	dev-libs/libxslt
	=kde-frameworks/karchive-${PVCUT}*:6
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-lang/perl
	dev-perl/URI
	nls? ( >=kde-frameworks/ki18n-${PVCUT}:6 )
"

CMAKE_SKIP_TESTS=(
	# bug 665622
	kdoctools_install
)

PATCHES=( "${FILESDIR}/${PN}-5.54.0-gentoo-docbundledir.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package nls KF6I18n)
	)

	ecm_src_configure
}
