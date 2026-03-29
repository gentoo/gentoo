# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils vala

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ximion/${PN}"
else
	MY_PV="v${PV}"
	SRC_URI="
		https://github.com/ximion/${PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz
		https://github.com/ximion/${PN}/commit/0135be63bc91d26969c3cdd90fee73c108b48684.patch
			-> ${P}-emit-strings.patch
		https://github.com/ximion/${PN}/commit/de5a582789be4931f7fe3958386b21763360ce4b.patch
			-> ${P}-drop-API-warning.patch
		https://github.com/ximion/${PN}/commit/9b92c867c48fb3a8494a51a761fa7e7605263907.patch
			-> ${P}-optional-tools.patch
		https://github.com/ximion/${PN}/commit/fb8726bc9b7f6d58a16153a149b4475fb912a312.patch
			-> ${P}-improve-heuristics.patch
		"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="Cross-distro effort for providing metadata for software in the Linux ecosystem"
HOMEPAGE="https://www.freedesktop.org/wiki/Distributions/AppStream/"

LICENSE="LGPL-2.1+ GPL-2+"
# check as_api_level
SLOT="0/5"
IUSE="apt bash-completion compose doc +introspection qt6 svg systemd tools test vala zstd"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.62:2
	>=net-misc/curl-7.62
	dev-libs/libfyaml
	dev-libs/libxml2:2=
	>=dev-libs/libxmlb-0.3.14:=
	dev-libs/snowball-stemmer:=

	bash-completion? (
		app-shells/bash-completion
	)
	compose? (
		>=x11-libs/cairo-1.12
		x11-libs/gdk-pixbuf:2
		media-libs/freetype:2
		x11-libs/pango
		media-libs/fontconfig:1.0
		svg? ( gnome-base/librsvg:2 )
	)
	introspection? (
		>=dev-libs/gobject-introspection-1.82.0-r2:=
	)
	qt6? (
		>=dev-qt/qtbase-6.4.2:6
	)
	systemd? (
		sys-apps/systemd:=
	)
	zstd? (
		app-arch/zstd:=
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-util/glib-utils
	dev-util/gperf
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	doc? ( app-text/docbook-xml-dtd:4.5 )
	test? ( dev-qt/qttools:6[linguist] )
	vala? ( $(vala_depend) )
"

PATCHES=(
	# Ensure certain values are always explicitly emitted as strings
	"${DISTDIR}/${P}-emit-strings.patch"
	# Drop API instability warning
	"${DISTDIR}/${P}-drop-API-warning.patch"
	# Allow disabling command-line tools
	"${DISTDIR}/${P}-optional-tools.patch"
	# yaml: Improve string quoting heuristics
	"${DISTDIR}/${P}-improve-heuristics.patch"
	# Fix tests
	"${FILESDIR}/${P}-fix-tests.patch"
	)

src_prepare() {
	default

	# Change docdir name
	sed -e "/^as_doc_target_dir/s/appstream/${PF}/" -i docs/meson.build || die

	use vala && vala_setup
}

src_configure() {
	xdg_environment_reset

	local emesonargs=(
		-Dcompose=false
		-Dmaintainer=false
		-Dstatic-analysis=false
		-Dstemming=true
		-Dapt-support=$(usex apt true false)
		-Dbash-completion=$(usex bash-completion true false)
		-Dcompose=$(usex compose true false)
		-Dgir=$(usex introspection true false)
		-Dqt=$(usex qt6 true false)
		-Dsvg-support=$(usex svg true false)
		-Dsystemd=$(usex systemd true false)
		-Dvapi=$(usex vala true false)
		-Dzstd-support=$(usex zstd true false)
		-Dtools=$(usex tools true false)

		-Ddocs=$(usex doc true false)
		-Dapidocs=$(usex doc true false)
		-Dinstall-docs=$(usex doc true false)
		-Dman=true
	)

	meson_src_configure
}
