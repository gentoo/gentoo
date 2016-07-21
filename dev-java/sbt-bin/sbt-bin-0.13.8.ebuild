# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2

DESCRIPTION="sbt, a build tool for Scala."
HOMEPAGE="http://scala-sbt.org"
SRC_URI="https://dl.bintray.com/sbt/native-packages/sbt/${PV}/${PN/-bin}-${PV}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

DEPEND=""
RDEPEND="
	>=virtual/jre-1.7
	!dev-java/sbt"

src_unpack() {
	default
	mv "${WORKDIR}/sbt" "${S}" || die
}

java_prepare() {
	java-pkg_init_paths_
}

src_install() {
	local dest="${JAVA_PKG_SHAREPATH}"

	rm -f bin/sbt.bat || die
	sed -i -e 's#bin/sbt-launch.jar#lib/sbt-launch.jar#g;' \
		bin/sbt-launch-lib.bash || die

	insinto "${dest}/lib"
	doins bin/* || die

	insinto "${dest}"
	doins -r conf || die

	fperms 0755 "${dest}/lib/sbt" || die
	dosym "${dest}/lib/sbt" /usr/bin/sbt || die
}
