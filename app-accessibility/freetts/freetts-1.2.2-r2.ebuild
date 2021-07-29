# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc examples source"
inherit java-pkg-2 java-ant-2

DESCRIPTION="A speech synthesis system written entirely in Java"
HOMEPAGE="https://freetts.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"

LICENSE="jsapi? ( sun-bcla-jsapi ) freetts"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE="jsapi mbrola"

DEPEND=">=virtual/jdk-1.8:*
	${RDEPEND}
	jsapi? ( app-arch/sharutils )"
RDEPEND=">=virtual/jre-1.8:*
	mbrola? ( >=app-accessibility/mbrola-3.0.1h-r6 ) "
BDEPEND="app-arch/unzip"

# Tests aren't present.
RESTRICT="test"

PATCHES=( "${FILESDIR}"/jsapi-gentoo.diff )

DOCS=( ANNOUNCE.txt README.txt RELEASE_NOTES )

src_prepare() {
	default
	# Prepare source directory.
	mkdir src || die "Failed to create source directory."
	mv com de src/ || die "Failed to move files to source directory."

	# Prepare library directory.
	cd lib || die "Lib directory not present."
	chmod 0755 jsapi.sh || die "jsapi.sh not present or can't change permissions."

	use mbrola && echo "mbrola.base=/usr/share/mbrola/" >> "${S}"/speech.properties
}

src_compile() {
	if use jsapi; then
		pushd lib
		./jsapi.sh || die "jsapi.sh failed"
		popd
	fi

	eant jars
}

# Tests aren't present.
# http://freetts.sourceforge.net/docs/index.php#how_test
#src_test() {
#	ANT_TASKS="ant-junit" eant junit
#}

src_install() {
	default
	java-pkg_dojar lib/*.jar mbrola/*.jar

	use mbrola && local jflags="--java_args -Dmbrola.base=/usr/share/mbrola"

	java-pkg_dolauncher ${PN} --main com.sun.speech.freetts.FreeTTS ${jflags}

	insinto /usr/share/${PN}
	doins speech.properties
	doins -r tools

	if use doc ; then
		docinto html
		dodoc -r docs/*
		java-pkg_dojavadoc javadoc
	fi

	if use examples ; then
		java-pkg_doexamples demo
	fi

	if use source ; then
		java-pkg_dosrc src/*
	fi
}
