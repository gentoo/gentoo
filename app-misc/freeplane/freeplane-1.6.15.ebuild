# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# based on: freeplane-1.5.18.ebuild

EAPI=7

inherit virtualx

DESCRIPTION="Java application for Mind Mapping, Knowledge and Project Management"
HOMEPAGE="https://www.freeplane.org/"
SRC_URI="mirror://sourceforge/${PN}/${PN}%20stable/${PN}_src-${PV}.tar.gz
	https://github.com/rtgiskard/pkgs/raw/master/gentoo/distfiles/${PF}-gradle-cache.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

JAVA_PKG_IUSE="doc"
VIRTUALX_REQUIRED="test"

RDEPEND=">=virtual/jre-1.8"
DEPEND="${DEPEND}
	>=virtual/jdk-1.8
	dev-java/gradle-bin"

src_compile() {
	GRADLE="gradle --gradle-user-home ${WORKDIR}/.gradle --console rich --no-daemon"
	GRADLE="${GRADLE} --offline"

	${GRADLE} build -x check -x test || die
}

src_test() {
	# disable --offline and then generate cache file with: ebuild clean test
	echo "pack cache file to reuse for offline building .."
	tar --xz -cf "${WORKDIR}/${PF}-gradle-cache.tar.xz" -C "${WORKDIR}" .gradle/caches/modules-2

	virtx ${GRADLE} check test || die
}

src_install() {
	cd BIN || die
	sed -e "/freepath=/s:=.*:=${EROOT}usr/share/${PN}:" \
		-i freeplane.sh
	newbin freeplane.sh freeplane

	insinto /usr/share/${PN}
	doins framework.jar freeplanelauncher.jar \
		freeplane.policy props.xargs init.xargs *.l4j.ini
	doins -r core doc fwdir plugins resources scripts

	doicon freeplane.svg
	make_desktop_entry freeplane
}
