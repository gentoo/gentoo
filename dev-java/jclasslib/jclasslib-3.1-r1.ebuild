# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java bytecode viewer"
HOMEPAGE="https://github.com/ingokegel/jclasslib"
SRC_URI="https://github.com/ingokegel/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

src_install() {
	java-pkg_dojar "build/${PN}.jar"

	java-pkg_dolauncher "${PN}" \
		--main org.gjt.jclasslib.browser.BrowserApplication

	use doc && java-pkg_dohtml -r doc/*
	use source && java-pkg_dosrc src/*
}

pkg_postinst() {
	elog "jclasslib uses Firefox by default."
	elog "Set the BROWSER environment at your discretion."
}
