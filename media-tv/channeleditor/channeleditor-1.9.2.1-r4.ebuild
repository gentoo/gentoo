# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit desktop java-pkg-2 java-pkg-simple xdg

DESCRIPTION="Editor for VDR channels.conf"
HOMEPAGE="https://sites.google.com/site/reniershomepage/channeleditor"
SRC_URI="https://downloads.sourceforge.net/project/channeleditor/channeleditor/$(ver_cut 1-3)/${P/-/_}_src.tar.gz"

S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

PATCHES=(
	# include localisation changes
	"${FILESDIR}"/${P}-messages.properties.patch
	"${FILESDIR}"/${P}-messages_en.properties.patch
)

JAVA_RESOURCE_DIRS="resources/src/java"
JAVA_SRC_DIR="src"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare

	xdg_environment_reset

	JAVA_MAIN_CLASS="$(grep Main build/MANIFEST.MF | cut -d' ' -f2 | tr -cd [:print:])"

	# java-pkg-simple expects resources in JAVA_RESOURCE_DIRS
	mkdir -p resources || die
	find src -type f ! -name '*.java' \
		! -name 'README' ! -name 'COPYRIGHT' \
		| xargs cp --parent -t resources || die
}

src_install() {
	java-pkg-simple_src_install
	make_desktop_entry channeleditor Channeleditor "" "Utility"
}
